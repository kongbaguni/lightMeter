//
//  Flash.swift
//  LightMeter
//
//  Created by Changyeol Seo on 11/18/25.
//
import SwiftUI

struct Flash {
    enum FlashStepInterpolation : Int, CaseIterable {
        case none        // 기본: 중간스텝 없음
        case halfStep    // 스텝 사이에 1개 (1/2 스톱)
        case thirdStep   // 스텝 사이에 2개 (1/3 스톱)
        
        var localizedString: String {
            switch self {
            case .none: return NSLocalizedString("flashStepInterpolation.none", comment: "flash setting")
            case .halfStep: return NSLocalizedString("flashStepInterpolation.Half Step", comment: "flash setting")
            case .thirdStep: return NSLocalizedString("flashStepInterpolation.Third Step", comment: "flash setting")
            }
        }
        static var items:[Models.Item] {
            FlashStepInterpolation.allCases.map { step in
                .init(value: Double(step.rawValue), title: step.localizedString)
            }
        }
    }
    
    let GN: Double
    let stop : Int
    let stepInterpolation: FlashStepInterpolation
    var items: [Models.Item] {
        var value = GN
        var result: [Models.Item] = [
            .init(value: GN, title: "Full")
        ]
        
        switch stepInterpolation {
        case .thirdStep:
            let dstep = 3.0  // 1스톱을 3등분            
            for i in 1...stop*3 {
                // 1/3 스톱 단위 감소
                value = GN * pow(2, -Double(i) / dstep)
                
                // title 계산
                let fractionTitle: String
                if i % 3 == 0 {
                    // 정수 스톱
                    let denominator = Int(pow(2.0, Double(i/3)))
                    fractionTitle = "1/\(denominator)"
                } else {
                    // 1/3 또는 2/3 스톱 → 분수표기 없음
                    fractionTitle = ""
                }
                
                result.append(.init(value: value, title: fractionTitle))
            }
            
        case .halfStep:
            let dstep = Double(2)
            for i in 1...stop*2 {
                // 0.5 stop 단위 감소
                value = GN * pow(2, -Double(i)/dstep)
                
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
        case .none:
            if stop > 20 {
                return result
            }
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
    DialView(items: Flash(GN: 15, stop: 6, stepInterpolation: .none).items, currentItem: .constant(.empty))
    
}
