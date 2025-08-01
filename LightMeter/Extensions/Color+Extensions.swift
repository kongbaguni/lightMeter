//
//  Color+Extensions.swift
//  PixelArtMaker (iOS)
//
//  Created by Changyul Seo on 2022/02/21.
//

import Foundation
import SwiftUI
extension Color {
    var ciColor : CIColor {
#if canImport(UIKit)
        typealias NativeColor = UIColor
#elseif canImport(AppKit)
        typealias NativeColor = NSColor
#endif
        
        let cgColor = NativeColor(self).cgColor
        return CIColor(cgColor: cgColor)
    }
    
    var string:String {
        ciColor.stringRepresentation
    }
    
    init(string:String) {
        let c = CIColor(string: string)
        self.init(CGColor(red: c.red, green: c.green, blue: c.blue, alpha: c.alpha))
    }
    
    init(rgb:Int) {
        self.init(
            red: Double((rgb >> 16) & 0xFF) / 255,
            green: Double((rgb >> 8) & 0xFF) / 255,
            blue: Double(rgb & 0xFF) / 255
        )
    }
    
    init(rgb:(Int,Int,Int)) {
        self.init(red: Double(rgb.0) / 255, green: Double(rgb.1) / 255, blue: Double(rgb.2) / 255)
    }
}

