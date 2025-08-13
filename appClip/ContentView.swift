//
//  ContentView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 6/30/25.
//

import SwiftUI

struct ContentView: View {
    @State var cameraManager:LightMeterCameraManager? = nil
    @State var lightMetterValue: Double? = nil
    @State var controlerEv:Double? = nil
    @State var isPlay:Bool = false
    var toggleButton : some View {
        ImageButtonView(systemName: isPlay ? "light.min" : "light.max") {
            if isPlay == false {
                isPlay = true
            }
        }
    }
    
   var evview : some View {
       if let a = lightMetterValue, let b = controlerEv {
           EVView(cameraEV: a, settingEV: b)
       } else {
           EVView(cameraEV: 0, settingEV: 0)
       }
    }
    
    var versionLabel: some View {
        HStack {
            Text("ver")
                .foregroundStyle(.secondary)
            Text(Bundle.main.version ?? "0.0.0")
                .foregroundStyle(.primary)
        }
    }
    
    var settingsButton: some View {
        NavigationLink {
            SettingView()
        } label: {
            ButtonImageView(systemName: "gearshape")
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            if geometry.size.width < geometry.size.height {
                VStack {
                    HStack {
                        evview
                        Spacer()
                        LightMetterIndicatorView(ev: lightMetterValue, settingEv: controlerEv, padding: 20)
                            .padding(10)
                    }
                    .padding(.horizontal, 10)
                    ControllerView(ev:$controlerEv)
                    HStack (alignment: .bottom) {
                        toggleButton
                    }
                    .padding(.bottom, 20)
                                        
                }
            } else {
                HStack {
                    VStack {
                        HStack {
                            evview
                            Spacer()
                            LightMetterIndicatorView(ev: lightMetterValue, settingEv: controlerEv, padding: 20)
                                .padding(10)
                        }
                    }
                    ScrollView {
                        ControllerView(ev:$controlerEv)
                    }
                    VStack {
                        toggleButton
                    }

                }
            }
        }
        
        .onAppear {
            isPlay = cameraManager?.isRunning ?? false
            cameraManager = LightMeterCameraManager { value in
                self.lightMetterValue = value
                UserDefaults.shared.set(cameraEv: value)
            } onStopSession: {
                self.isPlay = false
            }
        }
        .onChange(of: isPlay) {oldValue, newValue in
            if newValue == true {
                cameraManager?.startSession()
            }            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
