//
//  SlideDialView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/21/25.
//

import SwiftUI
import Foundation

struct SlideDialView: View {
    struct Item : Hashable {
        let value: Double
        let label: String
    }
    let items: [Item]
    @Binding var currentValue:Double
    
    private var currentItem:Item? {
        if self.items.count == 0 {
            return nil 
        }
        
        if let item = items.first(where: { item in
            return item.value == currentValue
        }) {
            return item
        }
        var distance:Double? = 1000
        var selectItem:Item? = nil
        for item in items {
            let dist = abs(item.value - currentValue)
            if dist < distance! {
                distance = dist
                selectItem = item
                currentValue = item.value
            }
        }
        return selectItem
    }
        
    var buttons : some View {
        Group {
            Button {
                selectPreviousItem()
            } label: {
                Image(systemName: "arrow.left")
                    .imageScale(.large)
                    .bold()
            }
            
            Button {
                selectNextItem()
            } label: {
                Image(systemName: "arrow.right")
                    .imageScale(.large)
                    .bold()
            }
        }
        .foregroundStyle(Color.accentColor)
        .padding(10)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.secondary)
        }
    }
    var scrollView : some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                LazyHStack(spacing:0) {
                    ForEach(items,id:\.self) { item in
                        Button {
                            currentValue = item.value
                        } label : {
                            Text(item.label)
                                .bold(item == currentItem)
                                .font(.system(size: item == currentItem ? 20 : 12))
                                .foregroundStyle(item == currentItem ? .red : .primary)
                                .padding(10)
                                .background {
                                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                                        .fill(item == currentItem ? Color.accentColor : Color.secondary)
                                }
                                .padding(.horizontal, 1)
                        }
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50)) {
                    selectItem(proxy: proxy)
                }
            }
            .onChange(of: currentValue) { newValue in
                selectItem(proxy: proxy)
                Log.debug("currentValue : ", currentValue, UserDefaults.standard.double(forKey: "aperture"))
            }
        }
        .frame(height:60)

    }
    var body: some View {
        HStack {
            scrollView
            buttons
        }
        .onAppear {
            if currentItem == nil {
                currentValue = items.first?.value ?? 0.0
            }
        }
    }
    
    private func selectItem(proxy : SwiftUI.ScrollViewProxy) {
        withAnimation {
            if let idx = items.firstIndex(where: { item in
                item.value == currentValue
            }) {
                proxy.scrollTo(items[idx], anchor: .center)
            }
        }
    }
    
    func selectPreviousItem() {
        if currentValue == items.first?.value {
            return
        }
        if let idx = items.firstIndex(where: { item in
            item.value == currentValue
        }) {
            currentValue = items[idx - 1].value
        }
    }
    
    func selectNextItem() {
        if currentValue == items.last?.value {
            return
        }
        if let idx = items.firstIndex(where: { item in
            item.value == currentValue
        }) {
            currentValue = items[idx + 1].value
        }
    }
}

#Preview {
    let items:[SlideDialView.Item] = [
        .init(value: 0.1, label: "0.1"),
        .init(value: 0.2, label: "0.2"),
        .init(value: 0.3, label: "0.3"),
        .init(value: 0.4, label: "0.4"),
        .init(value: 0.5, label: "0.5"),
        .init(value: 0.6, label: "0.6"),
        .init(value: 0.7, label: "0.7"),
        .init(value: 0.8, label: "0.8"),
        .init(value: 0.9, label: "0.9"),
        .init(value: 10.0, label: "10.0")
    ]
    SlideDialView(items: items, currentValue: .constant(items.last!.value))
                  
}
