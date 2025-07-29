//
//  LightMetterAutoManager.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/28/25.
//
import SwiftUI

public extension Notification.Name {
    static let lightMetterEvDidChanged = Notification.Name("lightMetterEvDidChanged")
    static let lightMetterStatusDidChanged = Notification.Name("lightMetterStatusDidChanged")
    static let lightMetterSelectNext = Notification.Name("lightMetterSelectNext")
    static let lightMetterSelectPrev = Notification.Name("lightMetterSelectPrev")
    static let lightMetterSettingChanged = Notification.Name("lightMetterSettingChanged")
    
}


struct LightMetterAutoView : View {
    @State var autoMode : Models.AutoMode = .manual

    @AppStorage("autoModeValue") var autoModeValue:Int = 0
    @AppStorage("aperture") var aperture:Double = 0.0
    @AppStorage("shutterSpeed") var shutterSpeed:Double = 0.0
    @State var status : LightMetterIndicatorView.Status = .off
    
    func autoSelectProcess(status:LightMetterIndicatorView.Status) {
        guard autoMode != .pause else {
            return
        }
        
        switch autoMode {
        case .modeA:
            switch status {
            case .매우부족, .약간부족:
                NotificationCenter.default.post(name: .lightMetterSelectNext, object: SlideDialView.ViewType.shutterSpeed)
            case .약간과노출, .과노출:
                NotificationCenter.default.post(name: .lightMetterSelectPrev, object: SlideDialView.ViewType.shutterSpeed)
            default:
                break
            }
        case .modeS:
            switch status {
            case .매우부족, .약간부족:
                NotificationCenter.default.post(name: .lightMetterSelectNext, object: SlideDialView.ViewType.aperture)
            case .약간과노출, .과노출:
                NotificationCenter.default.post(name: .lightMetterSelectPrev, object: SlideDialView.ViewType.aperture)
            default:
                break
            }
        default:
            break
        }

    }
    var body: some View {
        AutoModeSelectView(mode: $autoMode)
            .onAppear {
                autoMode = .init(rawValue: autoModeValue)!
            }
            .onChange(of: autoMode) { newValue in
                if autoMode != .pause {
                    autoModeValue = autoMode.rawValue
                    Log.debug("onchange automode aperture", aperture, "shutterSpeed", shutterSpeed)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .lightMetterStatusDidChanged)) { output in
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                    autoSelectProcess(status: output.object as? LightMetterIndicatorView.Status ?? .off)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .lightMetterSettingChanged)) { output in
                guard autoMode != .pause else {
                    return
                }
                let modeBackup = autoMode
                autoMode = .pause
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                    autoMode = modeBackup
                }
            }
    }
}
