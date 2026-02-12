//
//  RangeModeView.swift
//  LightMeter
//
//  Created by 서창열 on 2/12/26.
//

import SwiftUI

struct RangeModeView: View {
    @State private var distance:
    Float = 0
    var body: some View {
        ZStack {
            
            LiDARView(distance: $distance)
                .ignoresSafeArea()
            
            CrosshairView()

#if !targetEnvironment(simulator)
            VStack {
                NativeAdView()
                    .padding(.top, 5)
                Spacer()
            }
#endif

            VStack {
                Spacer()
                DistancePanel(distance: distance)
                    .padding(.bottom, 100)
            }
        }
    }
}

#Preview {
    RangeModeView()
}
