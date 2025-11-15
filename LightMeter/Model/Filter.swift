//
//  Filter.swift
//  LightMeter
//
//  Created by Changyeol Seo on 11/15/25.
//
import Foundation
import SwiftUI

enum FilterType : Int, CaseIterable {
    case clear
    case yellow
    case orange
    case red
    case green
    case blue
    case polarizer
    
    var stop : Double {
        switch self {
        case .clear:
            return 0
        case .yellow:
            return 1.0
        case .orange:
            return 1.5
        case .red:
            return 3
        case .green:
            return 2
        case .blue:
            return 2
        case .polarizer:
            return 2
        }
    }
    
    var color:Color {
        switch self {
        case .red:
            return .red
        case .orange:
            return .orange
        case .yellow:
            return .yellow
        case .clear:
            return .clear
        case .green:
            return .green
        case .blue:
            return .blue
        case .polarizer:
            return .black
        }
    }
    
    var label : Text {
        switch self {
        case .red:
            return Text("Red")
        case .orange:
            return Text("Orange")
        case .yellow:
            return Text("Yellow")
        case .clear:
            return Text("Clear")
        case .green:
            return Text("Green")
        case .blue:
            return Text("Blue")
        case .polarizer:
            return Text("Polarizer")
        }
    }
}
