//
//  Notification+Name.swift
//  LightMeter
//
//  Created by Changyeol Seo on 8/13/25.
//
import Foundation

public extension Notification.Name {
    static let lightMetterEvDidChanged = Notification.Name("lightMetterEvDidChanged")
    static let lightMetterStatusDidChanged = Notification.Name("lightMetterStatusDidChanged")
    static let lightMetterSelectNext = Notification.Name("lightMetterSelectNext")
    static let lightMetterSelectPrev = Notification.Name("lightMetterSelectPrev")
    static let lightMetterSettingChanged = Notification.Name("lightMetterSettingChanged")
    
}
