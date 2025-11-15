//
//  FilterSelectRow.swift
//  LightMeter
//
//  Created by Changyeol Seo on 11/15/25.
//

import SwiftUI

struct FilterSelectRow: View {
    let filter:FilterType
    let useCheckmark: Bool
    
    @AppStorage("filterType") var filterTypeRawValue: Int = 0
    
    var selectedFilter: FilterType {
        FilterType(rawValue: filterTypeRawValue) ?? .clear
    }
    
    var isSelected:Bool {
        selectedFilter == filter
    }
    
    var body: some View {
        HStack {
            if isSelected && useCheckmark {
                Image(systemName: "checkmark.circle")
            }
            Circle().fill(filter.color)
                .stroke(.primary)
                .frame(width: 20, height: 20)
            filter.label
                .foregroundStyle(isSelected ? .accent : .primary)
            Spacer()
        }
    }
}

#Preview {
    FilterSelectRow(filter: .green, useCheckmark: false)
}
