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
    
    static var empty: WidgetEntry {
        .init(date: .now, iso: "", aperture: "", shutterSpeed: "")
    }
    
    
    static var lastEntry: WidgetEntry? {
        if let iso = UserDefaults.shared.string(forKey: "widget_iso"),
           let aperture = UserDefaults.shared.string(forKey: "widget_aperture"),
           let shutterSpeed = UserDefaults.shared.string(forKey: "widget_shutterSpeed")
        {
            let date = Date(timeIntervalSince1970: UserDefaults.shared.double(forKey: "widget_updateDate"))
            return .init(date: date, iso: iso, aperture: aperture, shutterSpeed: shutterSpeed)
        }
        
        return nil
    }
}
