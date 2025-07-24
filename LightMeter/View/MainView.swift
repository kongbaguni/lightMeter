//
//  MainView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/24/25.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            NavigationStack {
                ContentView()
            }.toolbar {
                NavigationLink {
                    BodyListView()
                } label: {
                    Text("body list")
                }
            }
        }
        
    }
}

#Preview {
    MainView()
}
