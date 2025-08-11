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
                .foregroundStyle(.secondary)
            RoundedRectangle(cornerRadius: 3)
                .frame(width: 6, height: 50)
                .foregroundStyle(.secondary)
            
            VStack(alignment: .leading) {
                makeLabel(double: cameraEV)
                    .font(.system(size: 15).bold())
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
