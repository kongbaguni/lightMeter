//
//  ContentView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 6/30/25.
//

import SwiftUI
import GoogleMobileAds
import FirebaseCore

struct ContentView: View {
    init() {
#if !targetEnvironment(simulator)
        FirebaseApp.configure()
        GoogleMobileAds.MobileAds.shared.start { status in
            print(status)
            GoogleAdPrompt.promptWithDelay {
                
            }
        }
#endif
    }
    @State var cameraManager:LightMeterCameraManager? = nil
    @State var lightMetterValue: Double? =  UserDefaults.shared.double(forKey: "widget_cameraEv")
    @State var controlerEv:Double? = UserDefaults.shared.double(forKey: "widget_settingEv")
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
                        LightMetterIndicatorView(ev: lightMetterValue, settingEv: controlerEv)
                            .padding(10)
                    }
                    .padding(.horizontal, 10)
                    ControllerView(ev:$controlerEv)
                    HStack (alignment: .bottom) {
                        settingsButton
                        LightMetterAutoView()
                        toggleButton

                    }
                    .padding(.bottom, 20)
                    
#if !targetEnvironment(simulator)
                    NativeAdView()
                        .padding(.bottom, .safeAreaInsetBottom)
#endif
                    
                }
            } else {
                HStack {
                    VStack {
                        HStack {
                            evview
                            Spacer()
                            LightMetterIndicatorView(ev: lightMetterValue, settingEv: controlerEv)
                                .padding(10)
                        }
#if !targetEnvironment(simulator)
                        NativeAdView()
                            .padding(.bottom, .safeAreaInsetBottom)
#endif
                    }
                    ScrollView {
                        ControllerView(ev:$controlerEv)
                    }
                    VStack {
                        LightMetterAutoView()
                        toggleButton
                        settingsButton
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
