//
//  Body.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/25/25.
//
import AVFoundation

extension Models {
    struct Body : Codable {
        let id : Int
        let brand : String
        let name : String
        let shutterSpeeds : [String]
        
        var jsonString:String? {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            do {
                let data = try encoder.encode(self)
                return String(data:data, encoding: .utf8)
            } catch {
                
                return nil
            }
        }
        
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
            
            let customBodyList = UserDefaults.standard.loadCustomBodys()
            if customBodyList.count > 0 {
                let newidx = idx - bodys.count
                if newidx < customBodyList.count {
                    return customBodyList[newidx]
                }
            }
            return bodys[idx]
        }
    }
}
