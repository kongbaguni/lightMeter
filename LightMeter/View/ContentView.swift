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
        Group {
            if isPlay == false {
                Button {
                    isPlay.toggle()
                } label: {
                    Image(systemName: "play.fill")
                        .resizable()
                        .scaledToFit()
                }
            } else {
                Button {
                    isPlay.toggle()
                } label: {
                    Image(systemName: "stop.fill")
                        .resizable()
                        .scaledToFit()
                }
            }
        }.frame(height: 100)
    }
    
    var body: some View {
        GeometryReader { geometry in
            if geometry.size.width < geometry.size.height {
                VStack {
                    LightMetterIndicatorView(ev: lightMetterValue, settingEv: controlerEv)
                        .padding(10)
//                    #if DEBUG
//                    Text("\(lightMetterValue ?? 0.0)")
//                    Text("\(controlerEv ?? 0.0)")
//                    #endif
                    
                    Spacer()
                    ControllerView(ev:$controlerEv)
                    toggleButton
                    
                }
            } else {
                HStack {
                    LightMetterIndicatorView(ev: lightMetterValue, settingEv: controlerEv)
                        .padding(10)
                    ScrollView {
                        ControllerView(ev:$controlerEv)
                    }
                    toggleButton

                }
            }
        }
        .onAppear {
            isPlay = cameraManager?.isRunning ?? false
            cameraManager = LightMeterCameraManager { value in
                self.lightMetterValue = value
                
            }
        }
        .onChange(of: isPlay) { newValue in
            if newValue == true {
                cameraManager?.startSession()
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    isPlay = false
                }
            }
            else {
                cameraManager?.stopSession()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
