//
//  LightMetterCameraManager.swift
//  LightMeter
//
//  Created by Changyeol Seo on 6/30/25.
//

import AVFoundation
import SwiftUI
import CoreImage.CIFilterBuiltins

class LightMeterCameraManager: NSObject, ObservableObject {
    enum Area: String {
        case spot = "spot"
        case center = "center"
        case multi = "multi"
        var value : RelativeRect {
            switch self {
            case .spot:
                return .init(x: 0.5, y: 0.5, width: 0.1, height: 0.1)
            case .center:
                return .init(x: 0.5, y: 0.5, width: 0.5, height: 0.5)
            case .multi:
                return .init(x: 0, y: 0, width: 1, height: 1)
                                
            }
        }
        var rectValue:CGRect {
            .init(origin: value.origin, size: value.size)
        }
    }
    
    private let session = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    
    let lightMeterDidChange:(Double)->Void 
    init(lightMeterDidChange: @escaping (Double) -> Void) {
        self.lightMeterDidChange = lightMeterDidChange
    }
    
    var isRunning:Bool {
        session.isRunning
    }
    
    var captureArea:Area = .multi {
        didSet {
            if oldValue != captureArea {
                if session.isRunning {
                    stopSession()
                    startSession()
                }
            }
        }
    }
    
    func startSession() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        do {
            let input = try AVCaptureDeviceInput(device: device)
            session.beginConfiguration()
            session.sessionPreset = .photo
            
            if session.canAddInput(input) {
                session.addInput(input)
            }

            if session.canAddOutput(videoOutput) {
                session.addOutput(videoOutput)
                videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sampleBuffer"))
            }
            session.commitConfiguration()
            DispatchQueue.global().async { [weak session] in 
                session?.startRunning()
            }
            
            try device.lockForConfiguration()
            if device.isExposureModeSupported(.custom) {
                let iso = device.activeFormat.minISO
                let duration = CMTimeMake(value: 1, timescale: 1000)
                
                device.setExposureModeCustom(duration: duration, iso: iso, completionHandler: nil)
            }
            
            if device.isExposureModeSupported(.locked) {
                device.exposureMode = .locked
            }
            device.unlockForConfiguration()
        } catch {
            print("Camera init failed: \(error)")
        }
        

    }
    
    func stopSession() {
        session.stopRunning()
    }
    
    

    func calculateShutterSpeed(ev: Double, iso: Double, aperture: Double) -> Double {
        let evWithIso = ev + log2(iso / 100)
        let shutterSpeed = pow(aperture, 2) / pow(2.0, evWithIso)
        return shutterSpeed
    }
    
    func aperture(ev: Double, iso: Double, shutter: Double) -> Double {
        let evWithISO = ev + log2(iso / 100)
        return sqrt(shutter * pow(2.0, evWithISO))
    }
    
    func shutterSpeed(ev: Double, iso: Double, aperture: Double) -> Double {
        let evWithISO = ev + log2(iso / 100)
        return pow(aperture, 2) / pow(2.0, evWithISO)
    }
}

extension LightMeterCameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        CVPixelBufferLockBaseAddress(imageBuffer, .readOnly)
        
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let avgBrightness = ciImage.averageBrightness(area:self.captureArea)

        DispatchQueue.main.async {[weak self] in

            if let value = self?.avgBrightnessToEV(avgBrightness) {
                self?.lightMeterDidChange(value)
            }
        }
        

        CVPixelBufferUnlockBaseAddress(imageBuffer, .readOnly)
    }

    private func avgBrightnessToEV(_ brightness: Double) -> Double {
        // 대략적인 EV 추정 로직 (단순화)
        return log2(brightness * 100 + 1)
    }
}


extension CIImage {
    static let context:CIContext = .init()
    /// 이미지의 평균 밝기 (0.0 ~ 1.0)를 계산합니다.
    func averageBrightness(area:LightMeterCameraManager.Area) -> Double {
        // 1. CIAreaAverage 필터로 평균 색상 계산
        let extent = self.extent
        let filter = CIFilter.areaAverage()
        filter.inputImage = self
        let rect1 = CGRect(x: extent.origin.x, y: extent.origin.y, width: extent.size.width, height: extent.size.height)
        let rect2 = CIVector(cgRect: area.value.rect(for: rect1)).cgRectValue
        print("targetRect:", rect2)
        filter.extent = rect2
        guard let outputImage = filter.outputImage else {
            return 0.0
        }

        // 2. 1x1 픽셀 RGBA 데이터 추출
        var bitmap = [UInt8](repeating: 0, count: 4)
        CIImage.context.render(outputImage,
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: .init(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8,
                       colorSpace: CGColorSpaceCreateDeviceRGB())

        let r = Double(bitmap[0]) / 255.0
        let g = Double(bitmap[1]) / 255.0
        let b = Double(bitmap[2]) / 255.0

        print(bitmap)
        // 3. 밝기 계산 (Rec. 709)
        let brightness = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return brightness
    }
    
}
