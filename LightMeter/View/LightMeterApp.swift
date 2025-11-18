//
//  LightMeterApp.swift
//  LightMeter
//
//  Created by Changyeol Seo on 6/30/25.
//

import SwiftUI
import FirebaseCore
import GoogleMobileAds

@main
struct LightMeterApp: App {
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
            MainView()
        }
    }
}

