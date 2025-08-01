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
    @State var buttonAlignment:Alignment = .leading
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
        }.frame(width : 50, height: 50)
            .padding(20)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.secondary, lineWidth: 2)
            }
        
    }
    
    var toggleBtnAlignment: some View {
        Button {
            if buttonAlignment == .leading {
                buttonAlignment = .trailing
            } else {
                buttonAlignment = .leading
            }
        } label: {
            Image(systemName:
                    buttonAlignment == .leading
                  ? "button.vertical.left.press"
                  : "button.vertical.right.press"
            
            )
                .resizable()
                .scaledToFit()
                .frame(width : 50, height: 50)
                .padding(20)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.secondary, lineWidth: 2)
                }

        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            if geometry.size.width < geometry.size.height {
                VStack {
                    LightMetterIndicatorView(ev: lightMetterValue, settingEv: controlerEv)
                        .padding(10)                    
                    ControllerView(ev:$controlerEv, buttonAlignment: buttonAlignment)
                    HStack {
                        LightMetterAutoView()
                        toggleButton
                        toggleBtnAlignment
                    }
                    NativeAdView()
                }
            } else {
                HStack {
                    VStack {
                        LightMetterIndicatorView(ev: lightMetterValue, settingEv: controlerEv)
                            .padding(10)
                        NativeAdView()
                    }
                    ScrollView {
                        ControllerView(ev:$controlerEv, buttonAlignment: buttonAlignment)
                    }
                    VStack {
                        LightMetterAutoView()
                        toggleButton
                        toggleBtnAlignment
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
            buttonAlignment = UserDefaults.standard.bool(forKey: "buttonAlignment") ? .leading : .trailing
        }
        .onChange(of: isPlay) { newValue in
            if newValue == true {
                cameraManager?.startSession()
            }
            
        }
        .onChange(of: buttonAlignment) { newValue in
            UserDefaults.standard.set(newValue == .leading, forKey: "buttonAlignment")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
