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
    
    @State var isNeedUpdate:Bool = false
    init() {
#if !targetEnvironment(simulator)
        FirebaseApp.configure()
        GoogleMobileAds.MobileAds.shared.start { status in
            print(status)
            GoogleAdPrompt.promptWithDelay {
                
            }
        }
        UserDefaults.standard.fixIds()
#endif
    }
    
    func checkupdate() {
        StoreVersion.compareAppVersion(appId: .appId, currentVersion: .currentAppVersion) { result in
            Task { @MainActor in
                versionCheckResult = result
                switch versionCheckResult?.difference {
                case .majorHigherInStore, .minorHigherInStore, .patchHigherInStore:
                    isNeedUpdate = true
                default:
                    isNeedUpdate = false
                }
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isNeedUpdate {
                    VStack {
                        Text("Please update the app")
                            .font(.title)
                            .foregroundStyle(.primary)
                        Text("A new version of the app has been released on the App Store.")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Spacer().frame(height: 50)
                        Divider()
                        let currentVersion = versionCheckResult?.currentVersion ?? "unknown"
                        let storeVersion = versionCheckResult?.storeVersion ?? "unknown"
                        
                        Text(String(format: NSLocalizedString("store version : %@", comment: "update view"), storeVersion))
                        Text(String(format: NSLocalizedString("current version : %@", comment: "update view"), currentVersion))
                        Divider()
                        Spacer().frame(height: 50)
                        
                        Button {
                            let appStoreUrl = "itms-apps://itunes.apple.com/app/" + .appId
                            UIApplication.shared.open(URL(string: appStoreUrl)!)
                        } label: {
                            Text("goto app store")
                        }.padding(.vertical, 5)
                        
                        Button {
                            isNeedUpdate = false
                        } label: {
                            Text("Do it next time")
                        }.padding(.vertical, 5)
                        
                    }.padding()
                } else {
                    MainView()
                }
            }.onAppear {
                checkupdate()
            }
        }
    
    }
}

