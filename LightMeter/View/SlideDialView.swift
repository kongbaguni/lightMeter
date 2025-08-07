////
////  SlideDialView.swift
////  LightMeter
////
////  Created by Changyeol Seo on 7/21/25.
////
//
//import SwiftUI
//import Foundation
//
//struct SlideDialView: View {
//    let buttonAlignment: Alignment
//    enum ViewType {
//        case ev
//        case iso
//        case aperture
//        case shutterSpeed
//    }
//    
//    let viewType:ViewType
//    
//    let items: [Models.Item]
//    
//    @Binding var currentItem:Models.Item
//    
// 
//    var body: some View {
//        DialView(items: items, currentItem: $currentItem)
//    }
//    
//    
//   
//}
//
//#Preview {
//    let items:[Models.Item] = [
//        .init(value: 0.1, title: "0.1"),
//        .init(value: 0.2, title: "0.2"),
//        .init(value: 0.3, title: "0.3"),
//        .init(value: 0.4, title: "0.4"),
//        .init(value: 0.5, title: "0.5"),
//        .init(value: 0.6, title: "0.6"),
//        .init(value: 0.7, title: "0.7"),
//        .init(value: 0.8, title: "0.8"),
//        .init(value: 0.9, title: "0.9"),
//        .init(value: 10.0, title: "10.0")
//    ]
//    SlideDialView(buttonAlignment:.leading, viewType : .aperture ,items: items, currentValue: .constant(items.last!.value))
//                  
//}
//
////  SlideDialView.swift
////  LightMeter
////
////  Created by Changyeol Seo on 7/21/25.
////
//
//import SwiftUI
//import Foundation
//
//struct SlideDialView: View {
//    let buttonAlignment: Alignment
//    enum ViewType {
//        case ev
//        case iso
//        case aperture
//        case shutterSpeed
//    }
//    
//    let viewType:ViewType
//    
//    let items: [Models.Item]
//    
//    @Binding var currentItem:Models.Item
//    
// 
//    var body: some View {
//        DialView(items: items, currentItem: $currentItem)
//    }
//    
//    
//   
//}
//
//#Preview {
//    let items:[Models.Item] = [
//        .init(value: 0.1, title: "0.1"),
//        .init(value: 0.2, title: "0.2"),
//        .init(value: 0.3, title: "0.3"),
//        .init(value: 0.4, title: "0.4"),
//        .init(value: 0.5, title: "0.5"),
//        .init(value: 0.6, title: "0.6"),
//        .init(value: 0.7, title: "0.7"),
//        .init(value: 0.8, title: "0.8"),
//        .init(value: 0.9, title: "0.9"),
//        .init(value: 10.0, title: "10.0")
//    ]
//    SlideDialView(buttonAlignment:.leading, viewType : .aperture ,items: items, currentValue: .constant(items.last!.value))
//                  
//}
