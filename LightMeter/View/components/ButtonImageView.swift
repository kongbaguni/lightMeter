//
//  ButtonImageView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 8/10/25.
//

import SwiftUI

struct ButtonImageView: View {
    let systemName: String
    var body: some View {
        Image(systemName: systemName)
            .resizable()
            .scaledToFit()
            .frame(width: 32, height: 32)
            .padding(10)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.secondary)
            }
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .fill(.secondary.opacity(0.2))
            }
            .safeGlassEffect(useInteractive: true, inShape: RoundedRectangle(cornerRadius: 5))
        
    }
}

#Preview {
    ButtonImageView(systemName: "gearshape")
    
}
