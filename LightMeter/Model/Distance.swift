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
        let step = 5
        let a = min / step
        let b = max / step
        for i in a..<b {
            let value = Double(i * step)
            let title = String(format: "%0.0fcm", value)
            result.append(.init(value: value, title: title))
        }
        return result
    }
    
    static let defaultDistance: Distance = .init(min: 30, max: 700)
}
#Preview {
    DialView(items: Distance.defaultDistance.items, currentItem: .constant(.empty))
}
