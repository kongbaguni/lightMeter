//
//  Distance.swift
//  LightMeter
//
//  Created by Changyeol Seo on 11/18/25.
//
import SwiftUI

struct Distance {
    let min: Int
    let max: Int
    var items:[Models.Item] {
        var result: [Models.Item] = []
        for i in min..<max {
            let value = Double(i)
            result.append(.init(value: value, title: "\(value)cm"))
        }
        return result
    }
    
    static let defaultDistance: Distance = .init(min: 30, max: 700)
}
#Preview {
    DialView(items: Distance.defaultDistance.items, currentItem: .constant(.empty))
}
