//
//  CIImage+Extensions.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/22/25.
//
import CoreImage

extension CIImage {
    /// 이미지의 평균 밝기 (0.0 ~ 1.0)를 계산합니다.
    func averageBrightness(area:LightMeterCameraManager.Area) -> Double {
        // 1. CIAreaAverage 필터로 평균 색상 계산
        let extent = self.extent
        let filter = CIFilter.areaAverage()
        filter.inputImage = self
        let rect1 = CGRect(x: extent.origin.x, y: extent.origin.y, width: extent.size.width, height: extent.size.height)
        let rect2 = CIVector(cgRect: area.value.rect(for: rect1)).cgRectValue
        filter.extent = rect2
        guard let outputImage = filter.outputImage else {
            return 0.0
        }
        
                
        // 2. 1x1 픽셀 RGBA 데이터 추출
        var bitmap = [UInt8](repeating: 0, count: 4)
        CIContext().render(outputImage,
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: .init(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8,
                       colorSpace: CGColorSpaceCreateDeviceRGB())

        let r = Double(bitmap[0]) / 255.0
        let g = Double(bitmap[1]) / 255.0
        let b = Double(bitmap[2]) / 255.0
        // 3. 밝기 계산 (Rec. 709)
        let brightness = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return brightness
    }
    
}
