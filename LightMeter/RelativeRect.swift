//
//  RelativeRect.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/17/25.
//
import Foundation

/// 이미지 크기를 기준으로 0.0 ~ 1.0 사이의 상대 좌표를 나타내는 Rect
struct RelativeRect {
    let origin: CGPoint  // (x: 0.0 ~ 1.0, y: 0.0 ~ 1.0)
    let size: CGSize     // (width: 0.0 ~ 1.0, height: 0.0 ~ 1.0)
    init(origin: CGPoint, size: CGSize) {
        self.origin = origin
        self.size = size
    }
    
    init(x:CGFloat,y:CGFloat, width:CGFloat, height:CGFloat) {
        self.origin = .init(x: x, y: y)
        self.size = .init(width: width, height: height)
    }
    
}

extension RelativeRect {
    /// 이미지 사이즈에 맞게 절대 CGRect로 변환
    func rect(for imageExtent: CGRect) -> CGRect {
        let width = imageExtent.width * size.width
        let height = imageExtent.height * size.height
        return CGRect(
            x: imageExtent.width * origin.x - width * origin.x / 2,
            y: imageExtent.height * origin.y - height * origin.y / 2,
            width: imageExtent.width * size.width,
            height: imageExtent.height * size.height
        )
    }    
}
