//
//  Body.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/25/25.
//
import AVFoundation

extension Models {
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
}
