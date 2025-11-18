//
//  FilterTypeView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 11/14/25.
//

import SwiftUI

struct FilterTypeView : View {
    

    let filters = FilterType.allCases
    @State var selectedFilter: FilterType = .clear
    @AppStorage("filterType") var filterTypeRawValue: Int = 0
    
    var body: some View {
        NavigationLink {
            FilterListView()
        } label: {
            Circle()
                .fill(selectedFilter.color.opacity(0.5))
                .overlay(
                    Circle().stroke(.primary, lineWidth: 2)
                )
                .frame(width: 32, height: 32)
                .padding(10)
                .safeGlassEffect(useInteractive: true, inShape: Circle())

        }
        .onAppear {
            selectedFilter = .init(rawValue: filterTypeRawValue) ?? .clear
        }
    }
}

#Preview {
    NavigationStack {
        VStack(spacing: 16) {
            FilterTypeView()
        }
        .padding()
    }
}
