//
//  LightMetterIndicatorView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/18/25.
//

import SwiftUI

struct LightMetterIndicatorView: View {
    let ev:Double
    let settingEv:Double?
    
    enum Status {
        case less
        case current
        case more
        case off
    }
    var status:Status {
        guard let settingEv = settingEv else {
            return .off
        }
        let centerRange = settingEv - 0.1 ..< settingEv + 0.1
        if centerRange.contains(ev) {
            return .current
        }
        
        else if ev  < settingEv {
            return .less
        }
        
        return .more
    }
    
    var body: some View {
        HStack {
            Group {
                switch status {
                case .off:
                    Image(systemName: "arrowtriangle.forward")
                    Image(systemName: "circle")
                    Image(systemName: "arrowtriangle.left")
                case .less:
                    Image(systemName: "arrowtriangle.forward.fill")
                    Image(systemName: "circle")
                    Image(systemName: "arrowtriangle.left")
                case .current:
                    Image(systemName: "arrowtriangle.forward")
                    Image(systemName: "circle.fill")
                    Image(systemName: "arrowtriangle.left")
                case .more:
                    Image(systemName: "arrowtriangle.forward")
                    Image(systemName: "circle")
                    Image(systemName: "arrowtriangle.left.fill")
                }
            }.foregroundStyle(.red)
        }
    }
}

#Preview {
    LightMetterIndicatorView(ev: 0.0, settingEv: 0.5)
    LightMetterIndicatorView(ev: 0.5, settingEv: 0.5)
    LightMetterIndicatorView(ev: 0.35, settingEv: 0.5)
    
    LightMetterIndicatorView(ev: 1.0, settingEv: 0.5)
}
