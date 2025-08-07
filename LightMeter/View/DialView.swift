//
//  DialView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 8/6/25.
//

import SwiftUI

struct DialView: View {
    let items: [Models.Item]
    @Binding var currentItem: Models.Item

    @State private var itemWidth: CGFloat = 60
    @State private var scrollOffsetx: CGFloat = 0
    
    @State private var debounceTask: Task<Void, Never>? = nil

    @State private var isDragging: Bool = false
  
    @State private var isInitialized: Bool = false
    
    func scrollToCurrentIndex(scrollProxy: ScrollViewProxy) {
        if currentItem == .empty {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                scrollToCurrentIndex(scrollProxy: scrollProxy)
            }
            return
        }
        if let index = items.firstIndex(where: { $0 == currentItem }) {
            scrollProxy.scrollTo(index, anchor: .center)
        }
        isInitialized = true
    }
    
    func handleOffsetChanged(offset:CGFloat) {
        guard isInitialized else {
            return
        }
        
        let index = Int(round(offset / itemWidth))
        Log.debug(#function, index)
        
        if index < items.count && index >= 0 {
            currentItem = items[index]
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                ScrollViewReader { scrollProxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            ForEach(items.indices, id: \.self) { index in
                                ZStack {
                                    Rectangle()
                                        .fill(.primary)
                                        .frame(width: itemWidth + 2, height: 50)
                                        .opacity(0.2)
                                    Text(items[index].title)
                                        .font(.caption)
                                }
                                .frame(width: itemWidth)
                                .id(index)
                            }
                        }
                        .padding(.horizontal, geometry.size.width / 2 - itemWidth / 2)
                    }
                    .onScrollGeometryChange(for: CGPoint.self) { geometry in
                        geometry.contentOffset
                    } action: { oldValue, newValue in
                        scrollOffsetx = newValue.x
                        handleOffsetChanged(offset: newValue.x)
                    }
                    
                    .onAppear {
                        scrollToCurrentIndex(scrollProxy: scrollProxy)
                    }
                }
                
                // 중앙 포인터
                RoundedRectangle(cornerRadius: 5)
                    .fill(.red)
                    .frame(width: 10, height: 60)
                    .opacity(0.4)
            }
        }
        .frame(height: 60)
        .onDisappear {
            debounceTask?.cancel()
        }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

fileprivate struct TestView : View {
    
    @State var evFixItem:Models.Item = .init(value: 0.0, title: String(format:"%02.f", 0.0))
    
    var body: some View {
        VStack {
            Text(evFixItem.title)
            DialView(items: Models.EVfix.items, currentItem: $evFixItem)

        }
    }
    
    
}

#Preview {
  TestView()
}
