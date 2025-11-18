//
//  EVView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 8/8/25.
//

import SwiftUI

struct EVView: View {
    let cameraEV: Double
    let settingEV: Double
    
    func makeLabel(double: Double) -> some View {
        VStack {
            Text(String(format: "%02.2f", double))
        }
        
    }
    var body: some View {
        HStack {
            Text("ev")
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 6, height: 50)
                .foregroundStyle(.secondary)
                .opacity(0.5)
            
            VStack(alignment: .leading) {
                makeLabel(double: cameraEV)
                    .font(.system(size: 17).bold())
                    .foregroundStyle(.primary)
                makeLabel(double: settingEV)
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    EVView(cameraEV: 10, settingEV: 20)
}
