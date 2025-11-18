//
//  LightMeterApp.swift
//  LightMeter
//
//  Created by Changyeol Seo on 6/30/25.
//

import SwiftUI
import FirebaseCore
import GoogleMobileAds
import jkdsUtility

@main
struct LightMeterApp: App {
    
    @State var versionCheckResult: StoreVersion.VersionDifferenceCheckResult? = nil
    
    var isNeedUpdate:Bool {
        switch versionCheckResult?.difference {
        case .majorHigherInStore, .minorHigherInStore, .patchHigherInStore:
            return true
        default:
            return false
        }
    }
    
    init() {
#if !targetEnvironment(simulator)
        FirebaseApp.configure()
        GoogleMobileAds.MobileAds.shared.start { status in
            print(status)
            GoogleAdPrompt.promptWithDelay {
                
            }
        }
#endif
    }
    
    var body: some Scene {
        WindowGroup {
            if isNeedUpdate {
                VStack {
                    Text("Please update the app.")
                    Button {
                        let appStoreUrl = "itms-apps://itunes.apple.com/app/" + .appId
                        UIApplication.shared.open(URL(string: appStoreUrl)!)
                    } label: {
                        Text("goto app store")
                    }
                }
            } else {
                MainView()
                    .onAppear {
                        StoreVersion.compareAppVersion(appId: .appId, currentVersion: .currentAppVersion) { result in
                            Task { @MainActor in
                                versionCheckResult = result
                            }
                        }
                    }
            }
        }
    
    }
}

