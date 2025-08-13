//
//  WidgetEntry.swift
//  LightMeter
//
//  Created by Changyeol Seo on 8/13/25.
//
import WidgetKit


struct WidgetEntry: TimelineEntry {
    var date: Date
    let iso:String
    let aperture:String
    let shutterSpeed:String
    let settingEv:Double
    let cameraEv:Double
    
    static var empty: WidgetEntry {
        .init(date: .now, iso: "", aperture: "", shutterSpeed: "", settingEv: 0, cameraEv: 0)
    }
    
    
    static var lastEntry: WidgetEntry? {
        if let iso = UserDefaults.shared.string(forKey: "widget_iso"),
           let aperture = UserDefaults.shared.string(forKey: "widget_aperture"),
           let shutterSpeed = UserDefaults.shared.string(forKey: "widget_shutterSpeed")
            
        {
            let date = Date(timeIntervalSince1970: UserDefaults.shared.double(forKey: "widget_updateDate"))
            
            let settingEv:Double = UserDefaults.shared.double(forKey: "widget_settingEv")
            let cameraEv:Double = UserDefaults.shared.double(forKey: "widget_cameraEv")
            
            return .init(date: date, iso: iso, aperture: aperture, shutterSpeed: shutterSpeed, settingEv: settingEv, cameraEv: cameraEv)
        }
        
        return nil
    }
}
