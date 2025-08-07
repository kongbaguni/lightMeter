//
//  Item.swift
//  LightMeter
//
//  Created by Changyeol Seo on 8/7/25.
//
extension Models {
    struct Item  : Hashable, Equatable {
        static func == (lhs: Item, rhs: Item) -> Bool {
            return lhs.title == rhs.title && lhs.value == rhs.value
        }
        
        let value:Double
        let title:String
        static let empty:Item = .init(value: 0, title: "")
    }
}
