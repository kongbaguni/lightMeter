//
//  FilterListView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 11/15/25.
//

import SwiftUI

struct FilterListView: View {
    @AppStorage("filterType") var filterTypeRawValue: Int = 0
    var selectedFilter: FilterType {
        FilterType(rawValue: filterTypeRawValue) ?? .clear
    }
    
    var body: some View {
        List {
            Section("filter list") {
                ForEach(FilterType.allCases, id: \.self) { filter in
                    Button {
                        filterTypeRawValue = filter.rawValue
                    } label: {
                        FilterSelectRow(filter: filter, useCheckmark: true)
                    }
                }
            }
        }.navigationTitle("select filter")
    }
}

#Preview {
    NavigationStack {
        FilterListView()
    }
}
