//
//  FilterSelectView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 11/14/25.
//

import SwiftUI

extension Notification.Name {
    static let filterTypeChanged = Notification.Name("filterTypeChanged")
}

struct FilterTypeView : View {
    enum FilterType : Int, CaseIterable {
        case clear = 0
        case yellow = 1
        case orange = 2
        case red = 3
        var stop : Int {
            self.rawValue
        }
        
        var color:Color {
            switch self {
            case .red:
                return .red
            case .orange:
                return .orange
            case .yellow:
                return .yellow
            case .clear:
                return .clear
            }
        }
    }

    let filters = FilterType.allCases
    @State var selectedFilter: FilterType = .clear
    @State var isSheetPresented: Bool = false
    @AppStorage("filterType") var filterTypeRawValue: Int = 0
    
    var body: some View {
        Button {
            isSheetPresented = true
        } label: {
            Circle()
                .fill(selectedFilter.color)
                .overlay(
                    Circle().stroke(.primary, lineWidth: 2)
                )
                .frame(width: 40, height: 40)
                .padding(10)
        }
        .sheet(isPresented: $isSheetPresented) {
            FilterSelectView(selectedFilter: $selectedFilter)
        }
        .onChange(of: selectedFilter) { oldValue, newValue in
            filterTypeRawValue = newValue.rawValue
            NotificationCenter.default.post(name: .filterTypeChanged, object: selectedFilter)
        }
        .onAppear {
            selectedFilter = .init(rawValue: filterTypeRawValue) ?? .clear
        }
    }
}


struct FilterSelectView : View {
    @Environment(\.dismiss) private var dismiss

    @Binding var selectedFilter: FilterTypeView.FilterType
    
    var body: some View {
        VStack {
            Text("filter select")
            HStack {
                ForEach(FilterTypeView.FilterType.allCases, id: \.self) { type in
                    Button {
                        selectedFilter = type
                        dismiss()
                    } label: {
                        Circle()
                            .fill(type.color)
                            .stroke(type == selectedFilter ? .tertiary : .primary, lineWidth: type == selectedFilter ? 5 : 2)
                        
                            .frame(width: 32, height: 32)
                    }
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        FilterTypeView()

    }
    .padding()
}
