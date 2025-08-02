//
//  GADNativeAd+Extensions.swift
//  GaweeBaweeBoh
//
//  Created by 서창열 on 2023/08/02.
//

import Foundation
import SwiftUI
import GoogleMobileAds

extension NativeAd {
    func makeAdView(size:CGSize) -> some View {
        NadViewAdView(ad: self, size: size)        
    }
}

fileprivate struct NadViewAdView : UIViewRepresentable {
    typealias UIViewType = UIView
    
    let ad:NativeAd
    let size:CGSize
    
    func makeUIView(context: Context) -> UIView {
        let view = UnifiedNativeAdView(ad: ad, frame: .init(x: 0, y: 0, width: size.width, height: size.height))
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
//        uiView.frame.size.width = UIScreen.main.bounds.width
        uiView.frame.size = size
    }
}

