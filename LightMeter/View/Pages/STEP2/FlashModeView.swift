//
//  FlashControllerView.swift
//  LightMeter
//
//  Created by 서창열 on 11/18/25.
//

import Foundation
import SwiftUI

struct FlashModeView : View {
    @State var currentBody:Models.Body = Models.Body.curentBody!
    @State var currentLens:Models.Lens = Models.Lens.currentLens!

    @State var isoItem: Models.Item = .empty
    @State var apertureItem:Models.Item = .empty
    @State var flashItem: Models.Item = .empty
    @State var distanceItem: Models.Item = .empty
    
    
    @AppStorage("iso") var iso:Double = 0.0
    @AppStorage("aperture") var aperture:Double = 0.0

    @AppStorage("distance") var distance:Double = 0.0
    
    @AppStorage("flash") var flash:Double = 0.0
    
    @AppStorage("flashGN") var flashGN:Double = 15
    @AppStorage("flashStop") var flashStop:Int = 6
    @AppStorage("flashUseHarfStop") var flashUseHarfStop:Bool = true
    @AppStorage("usediffuser") var usediffuser:Bool = false
    @AppStorage("filterType") var filterTypeRawValue: Int = 0
    var fixedISO:Int {
        Int(makefilteredISO(iso: iso))
    }

    /** 계산된 적정 플래시 밝기 */
    var rightGN:Double {
        let iso = makefilteredISO(iso: isoItem.value)
        let fixDiffuser:Double = usediffuser ? 2.0 : 1.0
        return apertureItem
            .value * (distanceItem.value * 0.01) * sqrt(100 / (iso * 3.5)) * fixDiffuser
    }
    
    var flashModel:Flash {
        return .init(GN: flashGN, stop: flashStop, isHarfStop: flashUseHarfStop)
    }
    
    var toggleUsediffuserView : some View  {
        HStack {
            Text("use diffuser")
                .font(.system(size: 12))
                .foregroundStyle(.secondary)

            ImageButtonView(systemName: usediffuser ? "lightswitch.on" : "lightswitch.off" , onClick: {
                usediffuser.toggle()
            })
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
    
    func makefilteredISO(iso:Double)->Double {
        let type = FilterType(rawValue: filterTypeRawValue) ?? .clear
        let factor = pow(2.0, -type.stop)
        return iso * factor
    }
    
    
    var indicaterView: some View {
        LightMetterIndicatorView(ev: rightGN, settingEv: flash, padding: 20)
    }
    
    var controllerView : some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Flash")
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                            Text(String(format: "%0.2f", rightGN))
                            NavigationLink {
                                FlashSettingView()
                            } label: {
                                Text(String(format:"GN%0.2f", Double(flashItem.value)))
                                    .foregroundStyle(.primary)
                            }
                            
                        }
                        DialView(items: flashModel.items, currentItem: $flashItem)
                    }
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Distance")
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                            Text(String(format:"%0.2fcm", Double(distanceItem.value)))
                                .foregroundStyle(.primary)
                        }
                        DialView(items: Distance.defaultDistance.items, currentItem: $distanceItem)
                    }
                }
                
                
                
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
                
                HStack {
                    Text("Aperture").font(.system(size: 12)).foregroundStyle(.secondary)
                    Text("f").foregroundStyle(.secondary)
                    Text(apertureItem.title).foregroundStyle(.primary)
                    
                    Text("lens").foregroundStyle(.secondary)
                    lensListNavigationItem
                }
                DialView(items: currentLens.items.reversed(), currentItem: $apertureItem)
            }
                        
            HStack {
                Text("filter")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                FilterTypeView()
                toggleUsediffuserView
                NavigationLink {
                    SettingView()
                } label: {
                    ButtonImageView(systemName: "gearshape")
                }
            }.padding(.vertical, 8)
            
        }
    }
    
    var adView : some View {
#if !targetEnvironment(simulator)
        NativeAdView()
            .padding(.bottom, .safeAreaInsetBottom)
        
#else
        EmptyView()
#endif
    }
    var body: some View {
        GeometryReader { geo in
            if geo.size.width > geo.size.height {
                HStack {
                    VStack {
                        indicaterView
                        adView
                    }
                    VStack {
                        controllerView
                            .padding(10)
                    }
                }
                
            }
            else {
                VStack {
                    indicaterView
                    controllerView
                        .padding(10)
                    adView
                }
            }
        }
        .onAppear {
            

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
            
            if distanceItem == .empty {
                let items = Distance.defaultDistance.items
                distanceItem = items.first!
                for item in items {
                    if item.value == distance {
                        distanceItem = item
                        break
                    }
                }
            }
            
            if flashItem == .empty {
                flashItem = flashModel.items.first!
                for item in flashModel.items {
                    if item.value == flash {
                        flashItem = item
                        break
                    }
                }
            }
        }
        .onChange(of: isoItem) { oldValue, newValue in
            iso = newValue.value
        }
        .onChange(of: apertureItem) { oldValue, newValue in
            aperture = newValue.value
        }
        .onChange(of: distanceItem) { oldValue, newValue in
            distance = newValue.value
        }
        .onChange(of: flashItem) { oldValue, newValue in
            flash = newValue.value
        }
        .onReceive(NotificationCenter.default.publisher(for: .lightMetterSettingChanged)) { output in
            if let lens = Models.Lens.currentLens {
                currentLens = lens
            }
        }
        
    }
}

#Preview {
    NavigationStack {
        FlashModeView()
    }
}
