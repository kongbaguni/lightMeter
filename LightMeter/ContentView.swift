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
    
    @AppStorage("area") var area:LightMeterCameraManager.Area = .spot
    
    var body: some View {
        VStack {
            Text("\(lightMetterValue)")
            
            Button {
                isRunning.toggle()
                if isRunning {
                    cameraManager?.startSession()
                } else {
                    cameraManager?.stopSession()
                }
                
            } label: {
                Text( isRunning ? "stop" : "start")
            }
            
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
