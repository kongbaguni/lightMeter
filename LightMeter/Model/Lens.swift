//
//  Lens.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/25/25.
//
import Foundation

extension Models {
    struct Lens : Codable {
        let id : Int
        let brand : String
        let name : String
        let apertures : [Double]
        
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
        
        var items:[SlideDialView.Item] {
            apertures.reversed().map { aperture in
                return .init(value: aperture, label: .init(format:"%0.1f", aperture))
            }
        }
        
        static var lensList:[Lens] = []
        
        static func loadData() -> [Lens] {
            guard let url = Bundle.main.url(forResource: "lensList", withExtension: "json")
            else {
                return []
            }
            do {
                let data = try Data(contentsOf: url)
                return try JSONDecoder().decode([Lens].self, from: data)
            } catch {
                Log.debug(error.localizedDescription)
                return []
            }
        }
        
        static var currentLens : Lens? {
            if lensList.count == 0 {
                lensList = loadData()
            }
            
            let idx = UserDefaults.standard.integer(forKey: "lensSelectIdx")
            if idx < lensList.count {
                return lensList[idx]
            }
            
            let customLensList = UserDefaults.standard.loadCustomLens()
            if customLensList.count > 0 {
                let newidx = idx - lensList.count
                if newidx < customLensList.count {
                    return customLensList[newidx]
                }
            }
            
            UserDefaults.standard.set("0", forKey: "lensSelectIdx")
            return lensList.first
        }
    }


}
