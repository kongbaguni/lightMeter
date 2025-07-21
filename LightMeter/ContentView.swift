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
    
    @AppStorage("area") var area:LightMeterCameraManager.Area = .spot
    
    var body: some View {
        VStack {
            AreaView(size: .init(width: 40 * 5, height: 30 * 5), area: area)
            
            LightMetterIndicatorView(ev: lightMetterValue, settingEv: controlerEv)
            Text("\(lightMetterValue)")
            Text("\(controlerEv ?? 0.0)")
            
            HStack {
                Button {
                    area = .spot
                    cameraManager?.captureArea = .spot
                } label: {
                    Text("스팟측광")
                }.disabled(area == .spot)
                
                Button {
                    area = .center
                    cameraManager?.captureArea = .center
                } label: {
                    Text("중앙측광")
                }.disabled(area == .center)
                
                Button {
                    area = .multi
                    cameraManager?.captureArea = .multi
                } label: {
                    Text("다중측광")
                }.disabled(area == .multi)
                
            }
            
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
