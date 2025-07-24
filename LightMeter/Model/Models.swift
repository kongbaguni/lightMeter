//
//  Models.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/21/25.
//

struct Models {
    enum EVfix : Double, CaseIterable {
        case ev10 = 10
        case ev9 = 9
        case ev8 = 8
        case ev7 = 7
        case ev6 = 6
        case ev5 = 5
        case ev4 = 4
        case ev3 = 3
        case ev2 = 2
        case ev1 = 1
        case ev0 = 0
        case evNeg1 = -1
        case evNeg2 = -2
        case evNeg3 = -3
        case evNeg4 = -4
        case evNeg5 = -5
        case evNeg6 = -6
        case evNeg7 = -7
        case evNeg8 = -8
        case evNeg9 = -9
        case evNeg10 = -10
        
        var stringValue:String {
            String(format:"%02.f", rawValue)
        }
        
        static var items:[SlideDialView.Item] {
            EVfix.allCases.map { ev in
                return .init(value: ev.rawValue, label: ev.stringValue)
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
        
        static var items:[SlideDialView.Item] {
            ISO.allCases.map { iso in
                return .init(value: iso.rawValue, label: iso.stringValue)
            }
        }
    }
    
    enum Aperture: Double, CaseIterable {
        case f16 = 16
        case f13 = 13
        case f11 = 11
        case f9_5 = 9.5
        case f8 = 8
        case f6_7 = 6.7
        case f5_6 = 5.6
        case f4_8 = 4.8
        case f4 = 4
        case f3_4 = 3.4
        case f2_8 = 2.8
        case f2_4 = 2.4
        case f2 = 2
        var stringValue:String {
            String(format:"f%02.1f", rawValue)
        }
        static var items:[SlideDialView.Item] {
            allCases.map { aperture in
                return .init(value: aperture.rawValue, label: aperture.stringValue)
            }
        }
        
    }
    
    enum ShutterSpeed: Double, CaseIterable {
        case _4000 = 0.00025
        case _2000 = 0.0005
        case _1000 = 0.001
        case _500 = 0.002
        case _250 = 0.004
        case _125 = 0.008
        case _60 = 0.01666666
        case _30 = 0.03333333
        case _15 = 0.06666666
        case _8 = 0.125
        case _4 = 0.25
        case _2 = 0.5 // 1/2
        case s1 = 1
        case s2 = 2
        case s4 = 4
        case s5 = 8
        var stringValue: String {
            if self.rawValue < 1.0 {
                let denominator = 1.0 / rawValue
                return String(format: "1/%.0f", denominator)
            }
            return String(format: "\"%01.0f", rawValue)
        }
        
        static var items:[SlideDialView.Item] {
            allCases.map { shutterSpeed in
                return .init(value: shutterSpeed.rawValue, label: shutterSpeed.stringValue)
            }
        }
    }
}
