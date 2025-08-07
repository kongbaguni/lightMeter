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
    
    @State var evFixItem:Models.Item = .empty
    @State var isoItem:Models.Item = .empty
    @State var apertureItem:Models.Item = .empty
    @State var shutterSpeedItem:Models.Item = .empty
    
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
        if apertureItem != .empty {
            aperture = apertureItem.value
        }
        if shutterSpeedItem != .empty {
            shutterSpeed = shutterSpeedItem.value
        }
        if isoItem != .empty {
            iso = isoItem.value
        }
        if evFixItem != .empty {
            ev = calculateEV(aperture: aperture, shutter: shutterSpeed, iso: iso)
        }
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
                HStack {
                    VStack {
                        HStack {
                            Text("EV").font(.system(size: 12))
                            Text(evFixItem.title).foregroundStyle(.secondary)
                        }
                        DialView(items: Models.EVfix.items.reversed(), currentItem: $evFixItem)
                    }
                    VStack {
                        HStack {
                            Text("ISO").font(.system(size: 12))
                            Text(isoItem.title).foregroundStyle(.secondary)
                        }
                        DialView(items: Models.ISO.items.reversed(), currentItem: $isoItem)
                    }
                }
                
                HStack {
                    Text("Aperture").font(.system(size: 12))
                    Text(apertureItem.title).foregroundStyle(.secondary)
                    
                    Text("lens").foregroundStyle(.secondary)
                    lensListNavigationItem
                }
                DialView(items: currentLens.items.reversed(), currentItem: $apertureItem)

                HStack {
                    Text("ShutterSpeed").font(.system(size: 12))
                    Text(shutterSpeedItem.title).foregroundStyle(.secondary)
                    Text("body").foregroundStyle(.secondary)
                    bodyListNavigationItem
                }
                DialView(items: currentBody.items.reversed(), currentItem: $shutterSpeedItem)
            }
            Spacer()
        }
        .padding(10)
        .onAppear {
            currentBody = Models.Body.curentBody!
            currentLens = Models.Lens.currentLens!
        }
        .onChange(of: evFixItem) { oldValue, newValue in
            evFix = newValue.value
            calculateEV()
            
        }
        .onChange(of: isoItem) { oldValue, newValue in
            iso = newValue.value
            calculateEV()
        }
        .onChange(of: apertureItem) { oldValue, newValue in
            aperture = newValue.value
            calculateEV()
        }
        .onChange(of: shutterSpeedItem) { oldValue, newValue in
            shutterSpeed = newValue.value
            calculateEV()
        }
        .onAppear {
            if evFixItem == .empty {
                for item in Models.EVfix.items {
                    if item.value == evFix {
                        evFixItem = item
                    }
                }
            }
            if isoItem == .empty {
                for item in Models.ISO.items {
                    if item.value == iso {
                        isoItem = item
                    }
                }
            }
            
            if apertureItem == .empty {
                for item in currentLens.items {
                    Log.debug(aperture)
                    if item.value == aperture {
                        apertureItem = item
                    }
                }
                if apertureItem == .empty {
                    apertureItem = currentLens.items.first!
                }
            }
            
            if shutterSpeedItem == .empty {
                for item in currentBody.items {
                    if item.value == shutterSpeed {
                        shutterSpeedItem = item
                    }
                }
                if shutterSpeedItem == .empty {
                    shutterSpeedItem = currentBody.items.first!
                }
            }
            calculateEV()
        }
    }
}

#Preview {
    ControllerView(ev: .constant(0.0))
}
