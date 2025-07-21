//
//  SlideDialView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/21/25.
//

import SwiftUI

struct SlideDialView: View {
    struct Item : Hashable {
        let value: Double
        let label: String
    }
    let items: [Item]
    @Binding var currentValue:Double
    
    private var currentItem:Item? {
        items.first { item in
            return item.value == currentValue
        }
    }
    
    private var previesItem:Item? {
        if let idx = items.firstIndex(where: { item in
            return item.value == currentValue
        }) {
            if idx > 0 {
                return items[idx - 1]
            }
        }
        return nil
    }
    

    private var nextItem:Item? {
        if let idx = items.firstIndex(where: { item in
            return item.value == currentValue
        }) {
            if idx < items.count - 1 {
                return items[idx + 1]
            }
        }
        return nil
    }
    
    
    var body: some View {
        HStack {
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

            if let previesItem = previesItem {
                Text(previesItem.label)
            }
            
            if let currentItem = currentItem {
                Text(currentItem.label)
                    .foregroundStyle(.red)
            }
            if let nextItem = nextItem {
                Text(nextItem.label)
            }
            
        }
        .onAppear {
            if currentItem == nil {
                currentValue = items.first!.value
            }
        }
    }
    
    func selectPreviousItem() {
        Log.debug(#function, #line)
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
