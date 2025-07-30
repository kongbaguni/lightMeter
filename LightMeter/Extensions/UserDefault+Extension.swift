//
//  UserDefault+Extension.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/29/25.
//

import Foundation
extension UserDefaults {
    //MARK: Custom Bodys
    func loadCustomBodys()->[Models.Body] {
        guard let str = string(forKey: "customBodys"), let data = str.data(using: .utf8) else {
            return []
        }
            
        do {
            let list = try JSONDecoder().decode([Models.Body].self, from: data)
            return list
        } catch {
            Log.debug("error in loadCustomBodys", error.localizedDescription)
        }
        return []
    }
    
    func saveCustomBodys(_ bodys:[Models.Body]) {
        var str = "["
        for (idx, item) in bodys.enumerated() {
            if let json = item.jsonString {
                str.append(json)
                if idx < bodys.count-1 {
                    str.append(",")
                }
            }
        }
        str.append("]")
        setValue(str, forKey: "customBodys")
    }
    
    func addBody(body: Models.Body) {
        var bodys = loadCustomBodys()
        bodys.append(body)
        saveCustomBodys(bodys)
    }
    
    func removeBody(body:Models.Body) {
        var bodys = loadCustomBodys()
        while let idx = bodys.firstIndex(where: { item in
            return item.id == item.id
        }) {
            bodys.remove(at: idx)
        }
        saveCustomBodys(bodys)
    }
    
    // MARK: CustomLens
    func loadCustomLens()->[Models.Lens] {
        guard let str = string(forKey: "customLens"), let data = str.data(using: .utf8) else {
            return []
        }
        
        do {
            let list = try JSONDecoder().decode([Models.Lens].self, from: data)
            return list
        } catch {
            Log.debug("error in loadCustonLens", error.localizedDescription)
            return []
        }
    }
    
    func saveCustomLens(_ lens:[Models.Lens]) {
        var str = "["
        for (idx, item) in lens.enumerated() {
            if let json = item.jsonString {
                str.append(json)
                if idx < lens.count-1 {
                    str.append(",")
                }
            }
        }
        str.append("]")
        setValue(str, forKey: "customLens")
    }
    
    func addLens(lens: Models.Lens) {
        var lenss = loadCustomLens()
        lenss.append(lens)
        saveCustomLens(lenss)
    }
    
    func removeLens(lens:Models.Lens) {
        var lenss = loadCustomLens()
        while let idx = lenss.firstIndex(where: { item in
            return lens.id == item.id
        }) {
            lenss.remove(at: idx)
        }
        saveCustomLens(lenss)
    }
    
}
