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

    
    enum Lens {
        case ApoSummicron35
        case ApoSummicron50
        
        var apertureList : [Double] {
            switch self {
            case .ApoSummicron35, .ApoSummicron50:
                return [2.0, 2.4, 2.8, 4.0, 5.6, 8.0, 11, 16]
            }
        }
        
    }
    
    
    struct Body : Decodable {
        let brand : String
        let name : String
        let shutterSpeeds : [String]
        
        func convert(str:String)->CMTime{
            if str.contains("/") {
                let parts = str.split(separator: "/")
                if parts.count == 2,
                   let numerator = Int(parts[0]),
                   let denominator = Int(parts[1]) {
                    return CMTime(value: CMTimeValue(numerator), timescale: CMTimeScale(denominator))
                } else {
                    return .init()
                }
            } else if let value = Int(str) {
                return CMTime(value: CMTimeValue(value), timescale: 1)
            } else {
                return .init()
            }
        }
        
        var items:[SlideDialView.Item] {
            shutterSpeeds.reversed().map { str in
                return .init(value: convert(str: str).seconds, label: str)
            }
        }
    }
    static var bodys:[Body] = []

    static func loadBodyData() -> [Body] {
        guard let url = Bundle.main.url(forResource: "bodys", withExtension: "json")
        else {
            return []
        }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([Body].self, from: data)
        } catch {
            Log.debug(error.localizedDescription)
            return []
        }
    }
    
    static var curentBody : Body? {
        if bodys.count == 0 {
            bodys = loadBodyData()
        }
        let idx = UserDefaults.standard.integer(forKey: "bodySelectIdx")
        if bodys.count < idx {
            return bodys.last            
        }
        return bodys[idx]
    }
}
