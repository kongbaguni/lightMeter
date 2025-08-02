//
//  AdView.swift
//  GaweeBaweeBoh
//
//  Created by Changyeol Seo on 2023/07/11.
//

import SwiftUI
import ActivityIndicatorView
import GoogleMobileAds


extension Notification.Name {
    static let googleAdNativeAdClick = Notification.Name("googleAdNativeAdClick_observer")
    static let googleAdPlayVideo = Notification.Name("googleAdPlayVideo_observer")
}

struct NativeAdView : View {
    @State var loading = true
    @State var nativeAd:NativeAd? = nil
    @State var error:Error? = nil
    var body: some View {
        ZStack {
            if error == nil {
                GeometryReader { proxy in
                    if let view = nativeAd?.makeAdView(size: proxy.size) {
                        view
                    }
                }
                VStack(alignment: .center) {
                    ActivityIndicatorView(isVisible: $loading, type: .default()).frame(width: 50, height: 50)
                }
                
            }
        }.onAppear {
            loading = true
            AdLoader.shared.onError = { error in
                self.error = error
            }
            AdLoader.shared.getNativeAd(getAd: {[self] ad in
                nativeAd = ad
                loading = false
            })
        }
    }
}

