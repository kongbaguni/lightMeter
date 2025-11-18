//
//  MainView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/24/25.
//

import SwiftUI
import WidgetKit

struct MainView: View {
    @AppStorage("mainTabIdx") var tabIdx: Int = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                switch tabIdx {
                case 0:
                    NormalModeView()
                default:
                    FlashModeView()
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Button {
                            tabIdx = 0
                        } label: {
                            Text("mode1")
                        }
                        Button {
                            tabIdx = 1
                        } label: {
                            Text("mode2")
                        }
                    }
                }
            }
            
        }.onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { output in
            WidgetCenter.shared.reloadTimelines(ofKind: "widget")
        }
    }
}

#Preview {
    MainView()
}
