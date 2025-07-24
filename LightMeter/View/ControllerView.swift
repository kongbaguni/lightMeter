//
//  ControllerView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/18/25.
//

import SwiftUI

struct ControllerView: View {
    @Binding var ev:Double?
    // 밝기 보정
    let evFixOffset:CGFloat = 0
    
    @AppStorage("evfix") var evFix:Double = 0.0
    @AppStorage("iso") var iso:Double = Models.ISO.allCases.first!.rawValue
    @AppStorage("aperture") var aperture:Double = Models.Aperture.allCases.first!.rawValue
    @AppStorage("shutterSpeed") var shutterSpeed:Double = 0.0
    
    func calculateEV(aperture: Double, shutter: Double, iso: Double) -> Double? {
        if iso == 0 || shutter == 0 || aperture == 0 {
            return nil
        }
        let evBase = log2(pow(aperture, 2) / shutter)
        let isoCompensation = log2(iso / 100)
        return evBase - isoCompensation + evFix + evFixOffset
    }
    
    
    
   
    
    private func calculateEV() {
        ev = calculateEV(aperture: aperture, shutter: shutterSpeed, iso: iso)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("EV")
                SlideDialView(items: Models.EVfix.items, currentValue: $evFix)
                
                Text("ISO")
                SlideDialView(items: Models.ISO.items, currentValue: $iso)
                
                Text("Aperture")
                SlideDialView(items: Models.Aperture.items, currentValue: $aperture)
                
                Text("ShutterSpeed")
                SlideDialView(items: Models.curentBody?.items ?? [], currentValue: $shutterSpeed)
            }
            Spacer()
        }
        .padding(10)
        .onChange(of: evFix) { oldValue, newValue in
            calculateEV()
        }
        .onChange(of: iso) { oldValue, newValue in
            calculateEV()
        }
        .onChange(of: aperture) { oldValue, newValue in
            calculateEV()
        }
        .onChange(of: shutterSpeed) { oldValue, newValue in
            calculateEV()
        }
        .onAppear {
            calculateEV()
        }
    }
}

#Preview {
    ControllerView(ev: .constant(0.0))
}
