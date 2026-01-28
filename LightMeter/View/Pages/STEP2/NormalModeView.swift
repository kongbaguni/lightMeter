//
//  ContentView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 6/30/25.
//

import SwiftUI
import AVFoundation

struct NormalModeView: View {

    @State var cameraManager:LightMeterCameraManager? = nil
    @State var lightMetterValue: Double? =  UserDefaults.shared.double(forKey: "widget_cameraEv")
    @State var controlerEv:Double? = UserDefaults.shared.double(forKey: "widget_settingEv")
    @State var isPlay:Bool = false    
    @State var permissionOK:Bool = false
    
    /** 측광 버튼 */
    var meteringButton : some View {
        ImageButtonView(systemName: isPlay ? "light.min" : "light.max") {
            if isPlay == false {
                isPlay = true
            }
        }        
    }
    
   var evview : some View {
       Group {
           if let a = lightMetterValue, let b = controlerEv {
               EVView(cameraEV: a, settingEV: b)
           } else {
               EVView(cameraEV: 0, settingEV: 0)
           }
       }.padding(.horizontal, 10)
    }
    
    var versionLabel: some View {
        HStack {
            Text("ver")
                .foregroundStyle(.secondary)
            Text(Bundle.main.version ?? "0.0.0")
                .foregroundStyle(.primary)
        }
    }
    
    var contentView : some View {
        GeometryReader { geometry in
            if geometry.size.width < geometry.size.height {
                VStack {
                    HStack {
                        evview
                        Spacer()
                        LightMetterIndicatorView(ev: lightMetterValue, settingEv: controlerEv, padding: 20)
                            
                    }
                    ControllerView(ev:$controlerEv, cameraEvValue: $lightMetterValue)
                    HStack (alignment: .bottom) {
                        LightMetterAutoView()
                        FilterTypeView()
                        meteringButton
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
                            LightMetterIndicatorView(ev: lightMetterValue, settingEv: controlerEv, padding: 20)
                                
                        }
#if !targetEnvironment(simulator)
                        NativeAdView()
                            .padding(.bottom, .safeAreaInsetBottom)
#endif
                    }
                    ScrollView {
                        ControllerView(ev:$controlerEv, cameraEvValue: $lightMetterValue)
                    }
                    VStack {
                        LightMetterAutoView()
                        FilterTypeView()
                        meteringButton
                    }

                }
            }
        }
    }
    
    var body: some View {
        Group {
            if permissionOK {
                contentView
            } else {
                CameraPermissionView()
            }
        }
        .onAppear {
            isPlay = cameraManager?.isRunning ?? false
            cameraManager = LightMeterCameraManager { value in
                self.lightMetterValue = value
                UserDefaults.shared.set(cameraEv: value)
                NotificationCenter.default
                    .post(name: .lightMetterEvDidChanged, object: nil)
            } onStopSession: {
                self.isPlay = false
            }
            
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .notDetermined, .authorized:
                permissionOK = true
            default:
                permissionOK = false
            }
        }
        .onChange(of: isPlay) {oldValue, newValue in
            if newValue == true {
                cameraManager?.startSession()
            }
            
        }
    }
}

#Preview {
    NormalModeView()
}
