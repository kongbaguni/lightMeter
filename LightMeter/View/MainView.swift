//
//  MainView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/24/25.
//

import SwiftUI
import WidgetKit

struct MainView: View {
    var body: some View {
        NavigationStack {
            ContentView()
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { output in
                    WidgetCenter.shared.reloadTimelines(ofKind: "widget")
                }

        }
    }
}

#Preview {
    MainView()
}
