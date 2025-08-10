//
//  SettingView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 8/10/25.
//

import SwiftUI

struct SettingView: View {
    @State var currentBody:Models.Body = Models.Body.curentBody!
    @State var currentLens:Models.Lens = Models.Lens.currentLens!
    
    @AppStorage("hapticFeedbackSetting") var data:Int = 0

    var bodyListNavigationItem : some View {
        NavigationLink {
            BodyListView()
        } label: {
            HStack {
                Text("body")
                Text(currentBody.brand)
                    .bold()
                    .foregroundStyle(.primary)
                Text(currentBody.name)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    var lensListNavigationItem : some View {
        NavigationLink {
            LensListView()
        } label : {
            HStack {
                Text("lens")
                Text(currentLens.brand)
                    .bold()
                    .foregroundStyle(.primary)
                Text(currentLens.name)
                    .foregroundStyle(.secondary)
            }
        }
    }
    var body: some View {
        List {
            Section {
                HStack {
                    Text(Bundle.main.displayName!)
                }
                HStack {
                    Text("version")
                        .foregroundStyle(.secondary)
                    Text(Bundle.main.version!)
                        .foregroundStyle(.primary)
                }
            }
            Section {
                bodyListNavigationItem
                lensListNavigationItem
            }
            
            Section {
                Picker(selection: $data) {
                    Text("off").tag(0)
                    Text("light").tag(1)
                    Text("medium").tag(2)
                    Text("heavy").tag(3)
                } label: {
                    Text("haptic feedback")
                }

            }
        }
        .navigationTitle("setting")
    }
}

#Preview {
    SettingView()
}
