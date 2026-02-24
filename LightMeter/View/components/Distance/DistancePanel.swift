//
//  DistancePanel.swift
//  LightMeter
//
//  Created by 서창열 on 2/12/26.
//

import SwiftUI

struct DistancePanel: View {
    var distance: Float
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.7))
                .frame(height: 100)
                .safeGlassEffect(useInteractive: false, inShape:
                    RoundedRectangle(cornerRadius: 20)
                )
            
            Text(displayText)
                .font(.system(size: 52, weight: .medium, design: .rounded))
                .foregroundColor(.white)
        }
    }
    
    var displayText: String {
        if distance <= 0.05 {
            return "∞ m"
        } else {
            return String(format: "%.2f m", distance)
        }
    }
}
