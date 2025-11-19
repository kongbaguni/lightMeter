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
    @State var error:(err:Error,date:Date)? = nil
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                if let view = nativeAd?.makeAdView(size: proxy.size) {
                    view
                }
            }
            VStack(alignment: .center) {
                if nativeAd == nil {
                    if let error = error {
                        let err = error.err
                        let date = error.date
                        HStack {
                            Text(date.formatted(date: .omitted, time: .standard))
                                .font(.headline)
                                .foregroundStyle(.secondary)
                            Text(err.localizedDescription)
                                .font(.body)
                                .foregroundStyle(.primary)
                        }
                    }
                
                } else {
                    ActivityIndicatorView(isVisible: $loading, type: .default()).frame(width: 50, height: 50)
                }
            }
            
        }
        .background(
            Color.teal
        )
        .onAppear {
            loading = true
            AdLoader.shared.onError = { error in
                if let err = error {
                    self.error = (err,Date())
                }
                else {
                    self.error = nil
                }
                loading = false
            }
            AdLoader.shared.getNativeAd(getAd: {[self] ad in
                nativeAd = ad
                loading = false
            })
        }
    }
}

