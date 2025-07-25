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
    
    var toggleButton : some View {
        Group {
            if cameraManager?.isRunning == false {
                Button {
                    cameraManager?.startSession()
                } label: {
                    Image(systemName: "play.fill")
                }
            } else {
                Button {
                    cameraManager?.stopSession()
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
            cameraManager = LightMeterCameraManager { value in
                self.lightMetterValue = value
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
