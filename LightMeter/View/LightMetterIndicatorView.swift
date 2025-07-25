//
//  LightMetterIndicatorView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/18/25.
//

import SwiftUI

struct LightMetterIndicatorView: View {
    let ev:Double?
    let settingEv:Double?
    
    enum Status {
        case 매우부족
        case 약간부족
        case 정노출
        case 약간과노출
        case 과노출
        case off
    }
    
    var status:Status {
        
        guard let settingEv = settingEv, let ev = ev else {
            return .off
        }
        
        let shotRange:Double = 0.25
        let longRange:Double = 0.7

        if (settingEv - shotRange ..< settingEv + shotRange).contains(ev) {
            return .정노출
        }
        if (settingEv - longRange ..< settingEv + longRange).contains(ev) {
            if settingEv > ev {
                return .약간부족
            }
            return .약간과노출
        }
        
        else if ev  < settingEv {
            return .매우부족
        }
        
        return .과노출
    }
    
    var body: some View {
        HStack {
            Group {
                switch status {
                case .off:
                    Image(systemName: "arrowtriangle.forward")
                    Image(systemName: "circle")
                    Image(systemName: "arrowtriangle.left")
                case .매우부족:
                    Image(systemName: "arrowtriangle.forward.fill")
                        .foregroundStyle(.red)
                    Image(systemName: "circle")
                    Image(systemName: "arrowtriangle.left")
                case .약간부족:
                    Image(systemName: "arrowtriangle.forward.fill")
                        .foregroundStyle(.red)
                    Image(systemName: "circle.fill")
                        .foregroundStyle(.green)
                    Image(systemName: "arrowtriangle.left")
                case .정노출:
                    Image(systemName: "arrowtriangle.forward")
                    Image(systemName: "circle.fill")
                        .foregroundStyle(.green)
                    Image(systemName: "arrowtriangle.left")
                case .약간과노출:
                    Image(systemName: "arrowtriangle.forward")
                    Image(systemName: "circle.fill")
                        .foregroundStyle(.green)
                    Image(systemName: "arrowtriangle.left.fill")
                        .foregroundStyle(.red)
                case .과노출:
                    Image(systemName: "arrowtriangle.forward")
                    Image(systemName: "circle")
                    Image(systemName: "arrowtriangle.left.fill")
                        .foregroundStyle(.red)
                }
            }
        }
    }
}

#Preview {
    LightMetterIndicatorView(ev: 0.0, settingEv: nil)
    LightMetterIndicatorView(ev: 0.0, settingEv: 5.1)
    LightMetterIndicatorView(ev: 10.0, settingEv: 5.1)
    LightMetterIndicatorView(ev: 0.0, settingEv: 0.5)
    LightMetterIndicatorView(ev: 0.5, settingEv: 0.5)
    LightMetterIndicatorView(ev: 0.35, settingEv: 0.5)
    
    LightMetterIndicatorView(ev: 1.0, settingEv: 0.5)
}
