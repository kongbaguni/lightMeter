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
                }
            } else {
                Button {
                    isPlay.toggle()
                } label: {
                    Image(systemName: "stop.fill")
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            LightMetterIndicatorView(ev: lightMetterValue, settingEv: controlerEv)
                .padding(10)
            #if DEBUG
            Text("\(lightMetterValue ?? 0.0)")
            Text("\(controlerEv ?? 0.0)")
            #endif
            
            Spacer()
            ControllerView(ev:$controlerEv)
            toggleButton
            
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
