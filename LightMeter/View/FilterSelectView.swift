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
    

    let filters = FilterType.allCases
    @State var selectedFilter: FilterType = .clear
    @State var isSheetPresented: Bool = false
    @AppStorage("filterType") var filterTypeRawValue: Int = 0
    
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

    @Binding var selectedFilter: FilterType
    @State var willDismiss: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text("select filter")
                    .font(.title)
                    .foregroundStyle(.primary)
                Spacer()
            }.padding(.horizontal,10)
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach(FilterType.allCases, id: \.self) { type in
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
