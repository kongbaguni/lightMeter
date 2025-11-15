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
    enum FilterType : Double, CaseIterable {

        case clear
        case yellow
        case orange
        case red
        case green
        case blue
        case polarizer
        
        var stop : Double {
            switch self {
            case .clear:
                return 0
            case .yellow:
                return 1.0
            case .orange:
                return 1.5
            case .red:
                return 3
            case .green:
                return 2
            case .blue:
                return 2
            case .polarizer:
                return 2
            }
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
            case .green:
                return .green
            case .blue:
                return .blue
            case .polarizer:
                return .black
            }
        }
        
        var label : Text {
            switch self {
            case .red:
                return Text("Red")
            case .orange:
                return Text("Orange")
            case .yellow:
                return Text("Yellow")
            case .clear:
                return Text("Clear")
            case .green:
                return Text("Green")
            case .blue:
                return Text("Blue")
            case .polarizer:
                return Text("Polarizer")
            }
        }
    }

    let filters = FilterType.allCases
    @State var selectedFilter: FilterType = .clear
    @State var isSheetPresented: Bool = false
    @AppStorage("filterType") var filterTypeRawValue: Double = 0
    
    var body: some View {
        Button {
            isSheetPresented = true
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
    @State var willDismiss: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text("filter select")
                    .font(.title)
                    .foregroundStyle(.primary)
                Spacer()
            }.padding(.horizontal,10)
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach(FilterTypeView.FilterType.allCases, id: \.self) { type in
                        Button {
                            selectedFilter = type
                            willDismiss = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)){
                                dismiss()
                            }
                        } label: {
                            Circle()
                                .fill(type.color.opacity(0.5))
                                .stroke(type == selectedFilter ? .tertiary : .primary, lineWidth: type == selectedFilter ? 5 : 2)
                            
                                .frame(width: 32, height: 32)
                                .safeGlassEffect(useInteractive: true, inShape: Circle())
                                .padding(10)
                            
                        }.disabled(willDismiss)
                    }
                }.frame(height:100)
            }
            HStack {
                Text("Selected filter :")
                selectedFilter.label
                Spacer()
            }.padding(.horizontal,10)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        FilterTypeView()

    }
    .padding()
}
