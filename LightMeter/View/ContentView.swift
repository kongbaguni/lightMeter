//
//  ContentView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 6/30/25.
//

import SwiftUI

struct ContentView: View {
    @State var cameraManager:LightMeterCameraManager? = nil
    @State var lightMetterValue: Double = 0.0
    @State var isRunning: Bool = false
    @State var controlerEv:Double? = nil
    
    
    var body: some View {
        VStack {
            if let manager = cameraManager {
                ZStack {
                    CameraPreview(manager: manager)
                    if lightMetterValue > 0 {
                        LightMetterIndicatorView(ev: lightMetterValue, settingEv: controlerEv)
                            .padding(10)
                    }
                }
            }
            #if DEBUG
            Text("\(lightMetterValue)")
            Text("\(controlerEv ?? 0.0)")
            #endif
            
            
            ControllerView(ev:$controlerEv)
            
            Button {
                isRunning.toggle()
                if isRunning {
                    cameraManager?.startSession()
                } else {
                    cameraManager?.stopSession()
                }
                
            } label: {
                Group {
                    isRunning
                    ? Image(systemName: "stop")
                        .resizable()
                    : Image(systemName: "play")
                        .resizable()
                }
                .scaledToFit()
                .frame(width:50)
            }

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
