//
//  OrientationManager.swift
//  LightMeter
//
//  Created by Changyeol Seo on 11/18/25.
//


import SwiftUI
import Combine

class OrientationManager: ObservableObject {
    @Published var orientation: UIDeviceOrientation = UIDevice.current.orientation
    
    private var cancellable: AnyCancellable?
    
    init() {
        // 센서 활성화
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        
        cancellable = NotificationCenter.default
            .publisher(for: UIDevice.orientationDidChangeNotification)
            .sink { _ in
                self.orientation = UIDevice.current.orientation
            }
    }
}
