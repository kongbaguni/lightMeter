//
//  CrosshairView.swift
//  LightMeter
//
//  Created by 서창열 on 2/12/26.
//

import SwiftUI

struct CrosshairView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .stroke(style: StrokeStyle(lineWidth: 2, dash: [6]))
                .frame(width: 120, height: 120)
            
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .bold))
        }
        .foregroundColor(.white)
    }
}
