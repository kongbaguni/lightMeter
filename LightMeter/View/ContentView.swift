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
    @State var lightMetterValue: Double? = nil
    @State var controlerEv:Double? = nil
    @State var isPlay:Bool = false
    var toggleButton : some View {
        Group {
            if isPlay == false {
                Button {
                    isPlay.toggle()
                } label: {
                    Image(systemName: "light.min")
                        .resizable()
                        .scaledToFit()
                }
            } else {
                Image(systemName: "light.max")
                    .resizable()
                    .scaledToFit()
            }
        }.frame(width : .buttonRadius, height: .buttonRadius)
            .padding(20)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.secondary, lineWidth: 2)
            }
        
    }
    
   
    
    var body: some View {
        GeometryReader { geometry in
            if geometry.size.width < geometry.size.height {
                VStack {
                    LightMetterIndicatorView(ev: lightMetterValue, settingEv: controlerEv)
                        .padding(10)                    
                    ControllerView(ev:$controlerEv)
                    HStack {
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
                        LightMetterIndicatorView(ev: lightMetterValue, settingEv: controlerEv)
                            .padding(10)
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
                    }

                }
            }
        }
        .onAppear {
            isPlay = cameraManager?.isRunning ?? false
            cameraManager = LightMeterCameraManager { value in
                self.lightMetterValue = value
                
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
