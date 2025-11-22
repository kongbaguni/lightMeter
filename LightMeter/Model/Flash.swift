//
//  Flash.swift
//  LightMeter
//
//  Created by Changyeol Seo on 11/18/25.
//
import SwiftUI

struct Flash {
    let GN:Double
    let stop : Int
    let isHarfStop: Bool
    var items: [Models.Item] {
        var value = GN
        var result: [Models.Item] = [
            .init(value: GN, title: "Full")
        ]
        if isHarfStop {
            for i in 1...stop*2 {
                // 0.5 stop 단위 감소
                value = GN * pow(2, -Double(i)/2)
                
                // 분수 형태 title 계산
                let denominator = pow(2, Double(i/2))
                let fractionTitle: String
                if i % 2 == 0 {
                    // 정수 스톱
                    fractionTitle = "1/\(Int(denominator))"
                } else {
                    // 0.5 스톱 → √2 포함
                    fractionTitle = ""
                }
                
                result.append(.init(value: value, title: fractionTitle))
            }
        }
        else {
            var x = 1
            if stop > 1 {
                for _ in 0..<stop-1 {
                    value = value * 0.5
                    x *= 2
                    result.append(.init(value: value, title: "1/\(x)"))
                }
            }
        }
        return result
    }
}

#Preview {
    DialView(items: Flash(GN: 15, stop: 6, isHarfStop: false).items, currentItem: .constant(.empty))
    
}
