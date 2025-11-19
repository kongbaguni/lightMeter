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
    @State var errors:[(err:Error,date:Date)] = []
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                if let view = nativeAd?.makeAdView(size: proxy.size) {
                    view
                }
            }
            VStack(alignment: .center) {
                if errors.count > 0 {
                    List {
                        ForEach(0..<errors.count, id:\.self) { idx in
                            let err = errors[idx].err
                            let date = errors[idx].date
                            HStack {
                                Text("\(idx)").foregroundStyle(.secondary)
                                    .font(.body)
                                Text(date.formatted())
                                    .font(.headline)
                                    .foregroundStyle(.secondary)
                                Text(err.localizedDescription)
                                    .font(.body)
                                    .foregroundStyle(.teal)
                            }
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
                    self.errors.append((err,Date()))
                    loading = false
                }
            }
            AdLoader.shared.getNativeAd(getAd: {[self] ad in
                nativeAd = ad
                loading = false
            })
        }
    }
}

