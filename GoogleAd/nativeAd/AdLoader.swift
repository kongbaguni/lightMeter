//
//  AdLoader.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/27.
//

import Foundation
import GoogleMobileAds
#if DEBUG
fileprivate let adId = "ca-app-pub-3940256099942544/3986624511"
#else
fileprivate let adId = "ca-app-pub-7714069006629518/1695095083"
#endif

enum AdError : Error, LocalizedError {
    case loadingFailed
    case unknown
    var errorDescription: String? {
        switch self {
        case .loadingFailed:
            return NSLocalizedString("loading faild", comment: "ad loading")
        default:
            return nil
        }
    }
}

class AdLoader : NSObject {
    static let shared = AdLoader()
    private var onAdLoaded:(NativeAd?,Error?)->Void = { _,_ in }
    private var onDidFinishLoading:() -> Void = { }
    private let adLoader:GoogleMobileAds.AdLoader
  
    override init() {
        let option = MultipleAdsAdLoaderOptions()
        option.numberOfAds = 4
        adLoader = .init(adUnitID: adId,
                                    rootViewController: UIApplication.shared.lastViewController,
                                    adTypes: [.native], options: [option])
        super.init()
        adLoader.delegate = self
    }
    
    public func getNativeAd(getAd:@escaping(NativeAd?,Error?)->Void, onDidFinishLoading:@escaping()->Void) {
        self.onAdLoaded = getAd
        self.onDidFinishLoading = onDidFinishLoading
        adLoader.load(.init())
    }
    
  
}

extension AdLoader : NativeAdLoaderDelegate {
    func adLoader(_ adLoader: GoogleMobileAds.AdLoader, didFailToReceiveAdWithError error: any Error) {
        onAdLoaded(nil,error)
    }
    
    func adLoaderDidFinishLoading(_ adLoader: GoogleMobileAds.AdLoader) {
        onDidFinishLoading()
    }
    
    
    func adLoader(_ adLoader: GoogleMobileAds.AdLoader, didReceive nativeAd: GoogleMobileAds.NativeAd) {
        onAdLoaded(nativeAd,nil)
    }
    
}

