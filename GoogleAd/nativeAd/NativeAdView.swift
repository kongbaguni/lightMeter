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
            VStack(alignment: .center) {
                if nativeAd == nil {
                    if let err = error {
                        Button {
                            loadAd()
                        } label: {
                            ZStack {
                                Image(systemName: "camera.sensor.tag.radiowaves.left.and.right")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(100)
                                    .foregroundStyle(.white)
                                Text("")

#if DEBUG
                                Text(err.localizedDescription)
                                    .font(.body)
                                    .foregroundStyle(.primary)
                                    .padding(10)
                                    .background(.black.opacity(0.5))
#endif
                            }
                        }
                    }
                
                }
                else {
                    nativeAd?.makeAdView(size: .init(width: 372, height: 250))
                }
            }
            ActivityIndicatorView(isVisible: $loading, type: .default()).frame(width: 50, height: 50)
        }
        .frame(width: 372, height: 250)
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

