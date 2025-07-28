//
//  ControllerView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/18/25.
//

import SwiftUI

struct ControllerView: View {
    // 밝기 보정
    let evFixOffset:CGFloat = 0
    
    @Binding var ev:Double?
    @State var currentBody:Models.Body = Models.Body.curentBody!
    @State var currentLens:Models.Lens = Models.Lens.currentLens!
    
    @AppStorage("evfix") var evFix:Double = 0.0
    @AppStorage("iso") var iso:Double = 0.0
    @AppStorage("aperture") var aperture:Double = 0.0
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
    
    var bodyListNavigationItem : some View {
        NavigationLink {
            BodyListView()
        } label: {
            HStack {
                Text(currentBody.brand)
                    .bold()
                    .foregroundStyle(.primary)
                Text(currentBody.name)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    var lensListNavigationItem : some View {
        NavigationLink {
            LensListView()
        } label : {
            HStack {
                Text(currentLens.brand)
                    .bold()
                    .foregroundStyle(.primary)
                Text(currentLens.name)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("EV").font(.system(size: 12))
                SlideDialView(items: Models.EVfix.items, currentValue: $evFix)
                
                Text("ISO").font(.system(size: 12))
                SlideDialView(items: Models.ISO.items, currentValue: $iso)
                
                HStack {
                    Text("Aperture").font(.system(size: 12))
                    lensListNavigationItem
                }
                SlideDialView(items: currentLens.items, currentValue: $aperture)
                HStack {
                    Text("ShutterSpeed").font(.system(size: 12))
                    bodyListNavigationItem
                }
                SlideDialView(items: currentBody.items , currentValue: $shutterSpeed)
            }
            Spacer()
        }
        .padding(10)
        .onAppear {
//            currentBody = Models.Body.curentBody
//            currentLens = Models.Lens.currentLens
        }
        .onChange(of: evFix) {  newValue in
            calculateEV()
        }
        .onChange(of: iso) {  newValue in
            calculateEV()
        }
        .onChange(of: aperture) { newValue in
            calculateEV()
        }
        .onChange(of: shutterSpeed) { newValue in
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
