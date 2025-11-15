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
    @AppStorage("autoModeValue") var autoModeValue:Int = 0
    
    @AppStorage("filterType") var filterTypeRawValue: Int = 0
    
    @State var fixedISO:Int = 0
    
    func makefilteredISO(iso:Double)->Double {
        let type = FilterType(rawValue: filterTypeRawValue) ?? .clear
        let factor = pow(2.0, -type.stop)
        return iso * factor
    }
    
    var autoMode:Models.AutoMode {
        return .init(rawValue: autoModeValue)!
    }
           
    func calculateEV(aperture: Double, shutter: Double, iso: Double) -> Double? {
        if iso == 0 || shutter == 0 || aperture == 0 {
            return nil
        }
        let newISO = makefilteredISO(iso: iso)
        let evBase = log2(pow(aperture, 2) / shutter)
        let isoCompensation = log2(newISO / 100)
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
        if let ev = ev {
            UserDefaults.shared.set(
                iso: isoItem.title,
                aperture: apertureItem.title,
                shutterSpeed: shutterSpeedItem.title,                
            )
            UserDefaults.shared.set(settingEv: ev)
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
                    VStack(alignment: .leading) {
                        HStack {
                            Text("EV")
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                            Text(evFixItem.title)
                                .foregroundStyle(.primary)
                        }
                        DialView(items: Models.EVfix.items.reversed(), currentItem: $evFixItem)
                    }
                    VStack(alignment: .leading)  {
                        HStack {
                            Text("ISO")
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                            Text("\(Int(isoItem.value))")
                                .foregroundStyle(.primary)
                            
                            Text("\(fixedISO)")
                                .foregroundStyle(.red)
                        }
                        DialView(items: Models.ISO.items.reversed(), currentItem: $isoItem)
                    }
                }
                
                
                HStack {
                    Text("Aperture").font(.system(size: 12)).foregroundStyle(.secondary)
                    Text("f").foregroundStyle(.secondary)
                    Text(apertureItem.title).foregroundStyle(.primary)
                    
                    Text("lens").foregroundStyle(.secondary)
                    lensListNavigationItem
                }
                if autoMode != .modeS {
                    DialView(items: currentLens.items.reversed(), currentItem: $apertureItem)
                }

                HStack {
                    Text("ShutterSpeed").font(.system(size: 12))
                        .foregroundStyle(.secondary)
                    Text(shutterSpeedItem.title).foregroundStyle(.primary)
                    Text("sec").foregroundStyle(.secondary)
                    Text("body").foregroundStyle(.secondary)
                    bodyListNavigationItem
                }
                if autoMode != .modeA {
                    DialView(items: currentBody.items.reversed(), currentItem: $shutterSpeedItem)
                }
            }
            Spacer()
        }
        .padding(10)
        .onAppear {
            print(Int(makefilteredISO(iso: iso)))
            print(isoItem.title)
            print(isoItem.value)
            currentBody = Models.Body.curentBody!
            currentLens = Models.Lens.currentLens!
            fixedISO = Int(makefilteredISO(iso: iso))
            calculateEV()
        }
        .onChange(of: filterTypeRawValue, { oldValue, newValue in
            fixedISO = Int(makefilteredISO(iso: isoItem.value))
            calculateEV()

        })
        .onChange(of: evFixItem) { oldValue, newValue in
            evFix = newValue.value
            calculateEV()
            
        }
        .onChange(of: isoItem) { oldValue, newValue in
            iso = newValue.value
            fixedISO = Int(makefilteredISO(iso: isoItem.value))

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
                isoItem = Models.ISO.items.first!
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
        
        .onReceive(NotificationCenter.default.publisher(for: .lightMetterSelectNext)) { output in
            
            guard let type = output.object as? Models.ViewType else { return }
            switch type {
            case .aperture:
                let items = currentLens.items
                if let index = items.firstIndex(of: apertureItem) {
                    if index + 1 < items.count {
                        let nextIndex = index + 1
                        apertureItem = items[nextIndex]
                        aperture = items[nextIndex].value
                    }
                }
                
            case .shutterSpeed:
                let items = currentBody.items
                if let index = items.firstIndex(of: shutterSpeedItem) {
                    if index + 1 < items.count {
                        let nextIndex = index + 1
                        shutterSpeedItem = items[nextIndex]
                        shutterSpeed = items[nextIndex].value
                    }
                }

            default :
                break
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .lightMetterSelectPrev)) { output in
            guard let type = output.object as? Models.ViewType else { return }
            switch type {
            case .aperture:
                let items = currentLens.items
                if let index = items.firstIndex(of: apertureItem) {
                    if index - 1 >= 0 {
                        let nextIndex = index - 1
                        apertureItem = items[nextIndex]
                        aperture = items[nextIndex].value
                    }
                }
                
            case .shutterSpeed:
                let items = currentBody.items
                if let index = items.firstIndex(of: shutterSpeedItem) {
                    if index - 1 >= 0 {
                        let nextIndex = index - 1
                        shutterSpeedItem = items[nextIndex]
                        shutterSpeed = items[nextIndex].value
                    }
                }
                
            default :
                break
            }
        }
    }
}

#Preview {
    ControllerView(ev: .constant(0.0))
}
