//
//  Bundle+Extensions.swift
//  LightMeter
//
//  Created by Changyeol Seo on 8/10/25.
//
import Foundation

public extension Bundle {
    var name: String? { object(forInfoDictionaryKey: "CFBundleName") as? String }
    var displayName: String? { object(forInfoDictionaryKey: "CFBundleDisplayName") as? String }
    var version: String? { infoDictionary?["CFBundleShortVersionString"] as? String }
    var buildNumber: String? { infoDictionary?["CFBundleVersion"] as? String }
}
