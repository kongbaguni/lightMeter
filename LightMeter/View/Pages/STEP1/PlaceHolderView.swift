//
//  PlaceHolderView.swift
//  LightMeter
//
//  Created by 서창열 on 11/16/26.
//

import SwiftUI

struct PlaceHolderView: View {
    var body: some View {
        Image(systemName: "camera.aperture")
            .font(.system(size: 120))
            .foregroundStyle(.secondary)
    }
}

#Preview {
    PlaceHolderView()
}
