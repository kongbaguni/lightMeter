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
    
    let session = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    
    private var isoObservation: NSKeyValueObservation?
    private var exposureObservation: NSKeyValueObservation?

    
    let lightMeterDidChange:(Double)->Void
    let onStopSession:()->Void
    
    init(lightMeterDidChange: @escaping (Double) -> Void, onStopSession:@escaping ()->Void) {
        self.lightMeterDidChange = lightMeterDidChange
        self.onStopSession = onStopSession
        super.init()
    }
    
    var isRunning:Bool {
        session.isRunning
    }

    var changeCount:Int = 0
    
    private var iso:Float? = nil {
        didSet {
            postChange()
        }
    }
    private var shutterSpeed:CMTime? = nil {
        didSet {
            postChange()
        }
    }
    
    private func postChange() {
        lightMeterDidChange(calculateEV100())
        changeCount += 1
        if changeCount > 2 {
            self.stopSession()
            changeCount = 0
        }
    }
    private var lensAperture:Float? = nil
    
    var sessionConfig:Bool = false
    
       
    func startSession() {
        guard let device = AVCaptureDevice.default(for: .video) else {
            return
        }
        do {
            if sessionConfig == false {
                let input = try AVCaptureDeviceInput(device: device)
                session.beginConfiguration()
                session.sessionPreset = .photo
                
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                
                if session.canAddOutput(videoOutput) {
                    session.addOutput(videoOutput)
                }
                session.commitConfiguration()
                lensAperture = device.lensAperture
                
                sessionConfig = true
            }
            
            
            // ISO 변화 감지
            isoObservation = device.observe(\.iso, options: [.new]) { [weak self] device, change in
                if let newISO = change.newValue {
                    self?.iso = newISO
                }
            }
            
            // 노출시간 변화 감지
            exposureObservation = device.observe(\.exposureDuration, options: [.new]) { [weak self] device, change in
                if let newExposure = change.newValue {
                    print("셔터속도 변경됨: \(newExposure.seconds)초")
                    self?.shutterSpeed = newExposure
                }
            }
            
            DispatchQueue.global(qos: .userInitiated).async { [weak session] in
                session?.startRunning()
            }

        } catch {
            Log.debug("Camera init failed: \(error)")
        }
        

    }
    
    private func stopSession() {
        DispatchQueue.global(qos: .userInitiated).async { [weak session, weak self] in
            session?.stopRunning()
            DispatchQueue.main.async {
                self?.onStopSession()
            }
        }
        isoObservation?.invalidate()
        isoObservation = nil
        exposureObservation?.invalidate()
        exposureObservation = nil
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
    
    private func calculateEV100() -> Double {
        guard let shutterSpeed = self.shutterSpeed,
              let aperture = self.lensAperture,
              let iso = self.iso
        else {
            return 0
        }
        let t = shutterSpeed.seconds
        guard t > 0 else {
            return 0
        }
        let ev100 = log2((100.0 * pow(Double(aperture), 2)) / (Double(iso) * t))
        return ev100
    }
    
}



