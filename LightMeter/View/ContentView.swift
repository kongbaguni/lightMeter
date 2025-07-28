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
    
    var body: some View {
        GeometryReader { geometry in
            if geometry.size.width < geometry.size.height {
                VStack {
                    Spacer()
                    LightMetterIndicatorView(ev: lightMetterValue, settingEv: controlerEv)
                        .padding(10)                    
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
                
            } onStopSession: {
                self.isPlay = false
            }
        }
        .onChange(of: isPlay) { newValue in
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
