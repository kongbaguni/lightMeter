//
//  ControllerView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/18/25.
//

import SwiftUI

struct ControllerView: View {
    @Binding var ev:Double?
    
    @AppStorage("iso") var iso:Double = Models.ISO.allCases.first!.rawValue
    @AppStorage("aperture") var aperture:Double = Models.Aperture.allCases.first!.rawValue
    @AppStorage("shutterSpeed") var shutterSpeed:Double = Models.ShutterSpeed.allCases.first!.rawValue
    
    func calculateEV(aperture: Double, shutter: Double, iso: Double) -> Double? {
        if iso == 0 || shutter == 0 || aperture == 0 {
            return nil
        }
        let evBase = log2(pow(aperture, 2) / shutter)
        let isoCompensation = log2(iso / 100)
        return evBase - isoCompensation
    }
    
    
    
   
    
    private func calculateEV() {
        ev = calculateEV(aperture: aperture, shutter: shutterSpeed, iso: iso)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("ISO")
                SlideDialView(items: Models.ISO.items, currentValue: $iso)
                
                Text("Aperture")
                SlideDialView(items: Models.Aperture.items, currentValue: $aperture)
                
                Text("ShutterSpeed")
                SlideDialView(items: Models.ShutterSpeed.items, currentValue: $shutterSpeed)
            }
            Spacer()
        }
        .padding(10)
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
