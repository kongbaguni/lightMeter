//
//  HapticFeedback.swift
//  ucmIos
//
//  Created by Changyeol Seo on 1/14/25.
//
import UIKit
/**
 햅틱 피드백
 */
enum HapticFeedback {
    static func feedback() {
        let setting = UserDefaults.standard.integer(forKey: "hapticFeedbackSetting")
        switch setting {
        case 1:
            light()
        case 2:
            medium()
        case 3:
            heavy()
        default:
            break
        }
    }
    
    static func light() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    static func medium() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }

    static func heavy() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }

    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }
}
