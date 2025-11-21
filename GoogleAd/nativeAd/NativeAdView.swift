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
            GeometryReader { proxy in
                if let view = nativeAd?.makeAdView(size: proxy.size) {
                    view
                }
            }
            VStack(alignment: .center) {
                if nativeAd == nil {
                    if let err = error {
                        Button {
                            loadAd()
                        } label: {
                            Text(err.localizedDescription)
                                    .font(.body)
                                    .foregroundStyle(.primary)
                        }
                    }
                
                }
            }
            ActivityIndicatorView(isVisible: $loading, type: .default()).frame(width: 50, height: 50)

        }
        .background(
            Color.teal
        )
        .onAppear {
            loadAd()
            
        }
    }
    
    func loadAd() {
        loading = true
        AdLoader.shared.getNativeAd { ad, error in
            self.error = error
            self.nativeAd = ad
            
        } onDidFinishLoading: {
            loading = false
        }
    }
}

