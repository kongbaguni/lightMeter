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
        }
    }
    
    var imageView : some View {
        Image(systemName: imageName)
            .resizable()
            .frame(width: 32, height: 32)
    }
    var body: some View {
        Button {
            switch mode {
            case .manual:
                mode = .modeA
            case .modeA:
                mode = .modeS
            case .modeS:
                mode = .manual
            }
        } label: {
            imageView
        }
    }
}

#Preview {
    AutoModeSelectView(mode: .constant(.manual))
    AutoModeSelectView(mode: .constant(.modeS))
    AutoModeSelectView(mode: .constant(.modeA))
}
