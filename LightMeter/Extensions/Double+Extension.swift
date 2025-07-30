//
//  Double+Extension.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/30/25.
//

extension Double {
    var prettyString:String {
        return .init(format: "%.1f", self)
    }
}
