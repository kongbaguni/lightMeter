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
    
    @State var testItem:Models.Item = .init(value: 5, title: "5")
    @AppStorage("hapticFeedbackSetting") var hapticFeedbackSetting:Int = 0

    @AppStorage("filterType") var filterTypeRawValue: Int = 0
    var selectedFilter: FilterType {
        FilterType(rawValue: filterTypeRawValue) ?? .clear
    }

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
    
    var filterListNavigationItem : some View {
        NavigationLink {
            FilterListView()
        } label : {
            HStack {
                Text("filter")
                FilterSelectRow(filter: selectedFilter, useCheckmark: false)
            }
        }
    }
    
    var flashSettingNavigationItem : some View {
        NavigationLink {
            FlashSettingView()
        } label : {
            HStack {
                Text("flash setting")                
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
                filterListNavigationItem
                flashSettingNavigationItem
            }
            
            Section {
                Picker(selection: $hapticFeedbackSetting) {
                    Text("off").tag(0)
                    Text("light").tag(1)
                    Text("medium").tag(2)
                    Text("heavy").tag(3)
                } label: {
                    Text("haptic feedback")
                }
                
                if hapticFeedbackSetting != 0 {
                    DialView(items: [
                        .init(value: 0, title: "0"),
                        .init(value: 1, title: "1"),
                        .init(value: 2, title: "2"),
                        .init(value: 3, title: "3"),
                        .init(value: 4, title: "4"),
                        .init(value: 5, title: "5"),
                        .init(value: 6, title: "6"),
                        .init(value: 7, title: "7"),
                        .init(value: 8, title: "8"),
                        .init(value: 9, title: "9"),
                        .init(value: 10, title: "10"),
                    ], currentItem: $testItem)
                }
            }
        }
        .navigationTitle("setting")
    }
}

#Preview {
    SettingView()
}
