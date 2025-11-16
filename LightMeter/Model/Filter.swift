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
    
    case ND2
    case ND4
    case ND8
    case ND16
    case ND32
    case ND64
    case ND128
    case ND256
    case ND512
    case ND1024
    
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
        case .ND2:
            return 1
        case .ND4:
            return 2
        case .ND8:
            return 3
        case .ND16:
            return 4
        case .ND32:
            return 5
        case .ND64:
            return 6
        case .ND128:
            return 7
        case .ND256:
            return 8
        case .ND512:
            return 9
        case .ND1024:
            return 10
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
        case .ND2:
            return .black.opacity(0.1)
        case .ND4:
            return .black.opacity(0.2)
        case .ND8:
            return .black.opacity(0.3)
        case .ND16:
            return .black.opacity(0.4)
        case .ND32:
            return .black.opacity(0.5)
        case .ND64:
            return .black.opacity(0.6)
        case .ND128:
            return .black.opacity(0.7)
        case .ND256:
            return .black.opacity(0.8)
        case .ND512:
            return .black.opacity(0.9)
        case .ND1024:
            return .black
        }
    }
    
    var label : Text {
        switch self {
        case .red:
            return .init("Red")
        case .orange:
            return .init("Orange")
        case .yellow:
            return .init("Yellow")
        case .clear:
            return .init("Clear")
        case .green:
            return .init("Green")
        case .blue:
            return .init("Blue")
        case .polarizer:
            return .init("Polarizer")
        case .ND2:
            return .init("ND2")
        case .ND4:
            return .init("ND4")
        case .ND8:
            return .init("ND8")
        case .ND16:
            return .init("ND16")
        case .ND32:
            return .init("ND32")
        case .ND64:
            return .init("ND64")
        case .ND128:
            return .init("ND128")
        case .ND256:
            return .init("ND256")
        case .ND512:
            return .init("ND512")
        case .ND1024:
            return .init("ND1024")

        }
    }
}
