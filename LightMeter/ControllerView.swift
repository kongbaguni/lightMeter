//
//  ControllerView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/18/25.
//

import SwiftUI

struct ControllerView: View {
    @Binding var ev:Double
    
    @State var iso:Double = 0 {
        didSet {
            ev = calculateEV(aperture: aperture, shutter: shutterSpeed, iso: iso)
        }
    }
    @State var aperture:Double = 0 {
        didSet {
            ev = calculateEV(aperture: aperture, shutter: shutterSpeed, iso: iso)
        }
    }
    @State var shutterSpeed:Double = 0 {
        didSet {
            ev = calculateEV(aperture: aperture, shutter: shutterSpeed, iso: iso)
        }
    }
    
    func calculateEV(aperture: Double, shutter: Double, iso: Double) -> Double {
        if iso == 0 {
            return 0
        }
        if shutter == 0 {
            return 0
        }
        let evBase = log2(pow(aperture, 2) / shutter)
        let isoCompensation = log2(iso / 100)
        return evBase - isoCompensation
    }
    
    enum ISO : Double, CaseIterable {
        case m150 = 150
        case m200 = 200
        case m400 = 400
        
        var stringValue:String {
            String(format:"%02.f", rawValue)
        }
    }
    
    enum Aperture: Double, CaseIterable {
        case f2 = 2
        case f3 = 3
        case f4 = 4
        case f5 = 5
        case f8 = 8
        case f11 = 11
        case f16 = 16
        case f22 = 22
        var stringValue:String {
            String(format:"f%02.f", rawValue)
        }
    }
    
    enum ShutterSpeed: Double, CaseIterable {
        case s4000 = 0.00025
        case s3000 = 0.0003333
        case s2000 = 0.0005
        case s1000 = 0.001
        case s500 = 0.002
        case s100 = 0.01
        case s50 = 0.02
        case s10 = 0.1
        case s1 = 1
        case s2 = 2
        case s3 = 3
        case s4 = 4
        case s5 = 5
        var stringValue: String {
            if self.rawValue < 1.0 {
                let denominator = 1.0 / rawValue
                return String(format: "1/%.0f", denominator)
            }
            return String(format: "\"%01.0f", rawValue)
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("ISO")
                ForEach(ISO.allCases, id:\.self) { iso in
                    Button {
                        self.iso = iso.rawValue
                    } label: {
                        Text(iso.stringValue)
                    }.disabled(self.iso == iso.rawValue)
                }
            }
            
            HStack {
                Text("Aperture")
                ForEach(Aperture.allCases, id:\.self) { aperture in
                    Button {
                        self.aperture = aperture.rawValue
                    } label: {
                        Text(aperture.stringValue)
                    }.disabled(self.aperture == aperture.rawValue)
                }
            }
            
            HStack {
                Text("ShutterSpeed")
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(ShutterSpeed.allCases, id:\.self) { shutterSpeed in
                            Button {
                                self.shutterSpeed = shutterSpeed.rawValue
                                
                            } label: {
                                Text(shutterSpeed.stringValue)
                            }
                            .frame(width: 70)
                            .disabled(self.shutterSpeed == shutterSpeed.rawValue)
                        }
                    }
                }.frame(height: 100)
                
            }
        }
    }
}

#Preview {
    ControllerView(ev: .constant(0.0))
}
