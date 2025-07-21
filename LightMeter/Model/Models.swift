//
//  Models.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/21/25.
//

struct Models {
    enum ISO : Double, CaseIterable {
        case m30 = 30
        case m50 = 50
        case m80 = 80
        case m100 = 100
        case m150 = 150
        case m200 = 200
        case m400 = 400
        case m800 = 800
        case m1600 = 1600
        case m3200 = 3200
        case m6400 = 6400
        case m12800 = 12800
        case m25600 = 25600
        
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
        case f22 = 22
        case f16 = 16
        case f11 = 11
        case f8 = 8
        case f5_6 = 5.6
        case f4 = 4
        case f3 = 3
        case f2 = 2
        case f1_8 = 1.8
        case f1_4 = 1.4
        case f1 = 1
        case f0_9 = 0.9
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
