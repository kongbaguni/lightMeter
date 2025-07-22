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
    private var ciImage: CIImage? = nil
    
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
    
    let session = AVCaptureSession()
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
            
            try device.lockForConfiguration()
            if device.isExposureModeSupported(.custom) {
                let minISO = device.activeFormat.minISO
                let maxISO = device.activeFormat.maxISO
                let midISO = (minISO + maxISO) / 2.0
                                
                let desiredDuration =  CMTimeMake(value: 1, timescale: 500)
                
                device.setExposureModeCustom(duration: desiredDuration, iso: midISO, completionHandler: nil)
                
            }
            
            device.unlockForConfiguration()
            
            DispatchQueue.global().async { [weak session] in
                session?.startRunning()
            }

        } catch {
            Log.debug("Camera init failed: \(error)")
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
        
        ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let avgBrightness = ciImage?.averageBrightness(area:self.captureArea) else {
            return
        }

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


