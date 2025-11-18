//
//  AutoModeSelectView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/28/25.
//

import SwiftUI

struct AutoModeSelectView: View {
    @Binding var mode: Models.AutoMode
    
    var imageName:String {
        switch mode {
        case .manual:
            return "m.circle"
        case .modeA:
            return "a.circle"
        case .modeS:
            return "s.circle"
        case .pause:
            return "circle"
        }
    }
    
    
    var body: some View {
        ImageButtonView(systemName: imageName) {
            switch mode {
            case .manual:
                mode = .modeA
            case .modeA:
                mode = .modeS
            case .modeS:
                mode = .manual
            default:
                break
            }
        }
    }
}

#Preview {
    AutoModeSelectView(mode: .constant(.manual))
    AutoModeSelectView(mode: .constant(.modeS))
    AutoModeSelectView(mode: .constant(.modeA))
}
