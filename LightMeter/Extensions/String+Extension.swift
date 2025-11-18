//
//  String+Extension.swift
//  LightMeter
//
//  Created by 서창열 on 11/18/25.
//
import Foundation
extension String {
    static var currentAppVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    static let appId:String = "6748942481"
}
