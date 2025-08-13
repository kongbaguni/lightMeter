//
//  SharedDefaults.swift
//  LightMeter
//
//  Created by Changyeol Seo on 8/13/25.
//

import Foundation

extension UserDefaults {
    static let shared = UserDefaults(suiteName: "group.net.kongbaguni.lightMeter")!
    
    func set(iso:String, aperture:String, shutterSpeed:String) {
        set(Date.now.timeIntervalSince1970, forKey: "widget_updateDate")
        set(iso, forKey: "widget_iso")
        set(aperture, forKey: "widget_aperture")
        set(shutterSpeed, forKey: "widget_shutterSpeed")
        synchronize()
    }
    
    func set(cameraEv:Double) {
        set(cameraEv, forKey: "widget_cameraEv")
        synchronize()
    }
    
    func set(settingEv:Double) {
        set(settingEv, forKey: "widget_settingEv")
        synchronize()
    }
}
