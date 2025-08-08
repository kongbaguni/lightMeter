//
//  Models.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/21/25.
//
import AVFoundation
import SwiftUI

struct Models {
    enum EVfix : Double, CaseIterable {
        case ev10 = 3.0
        case ev9 = 2.7
        case ev8 = 2.4
        case ev7 = 2.1
        case ev6 = 1.8
        case ev5 = 1.5
        case ev4 = 1.2
        case ev3 = 0.9
        case ev2 = 0.6
        case ev1 = 0.3
        case ev0 = 0
        case evNeg1 = -0.3
        case evNeg2 = -0.6
        case evNeg3 = -0.9
        case evNeg4 = -1.2
        case evNeg5 = -1.5
        case evNeg6 = -1.8
        case evNeg7 = -2.1
        case evNeg8 = -2.4
        case evNeg9 = -2.7
        case evNeg10 = -3.0
        
        var stringValue:String {
            String(format:"%0.1f", rawValue)
        }
        
        static var items:[Models.Item] {
            EVfix.allCases.map { ev in
                return .init(value: ev.rawValue, title: ev.stringValue)
            }
        }
        
    }
    
    enum ISO : Double, CaseIterable {
        case m25 = 25
        case m50 = 50
        case m64 = 64
        case m80 = 80
        case m100 = 100
        case m125 = 125
        case m160 = 160
        case m200 = 200
        case m250 = 250
        case m320 = 320
        case m400 = 400
        case m500 = 500
        case m640 = 640
        case m800 = 800
        case m1000 = 1000
        case m1250 = 1250
        case m1600 = 1600
        case m2000 = 2000
        case m3200 = 3200
        
        var stringValue:String {
            String(format:"%02.f", rawValue)
        }
        
        static var items:[Models.Item] {
            ISO.allCases.map { iso in
                return .init(value: iso.rawValue, title: iso.stringValue)
            }
        }
    }
    
  
}
