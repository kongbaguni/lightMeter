//
//  LiDARView.swift
//  LightMeter
//
//  Created by 서창열 on 2/12/26.
//
import SwiftUI
import ARKit
import RealityKit

struct LiDARView: UIViewRepresentable {
    
    @Binding var distance: Float
    
    class Coordinator: NSObject, ARSessionDelegate {
        
        var parent: LiDARView
        var smoothedDistance: Float = 0
        
        init(parent: LiDARView) {
            self.parent = parent
        }
        
        func session(_ session: ARSession, didUpdate frame: ARFrame) {
            
            guard let depth = frame.sceneDepth else { return }
            
            let depthMap = depth.depthMap
            CVPixelBufferLockBaseAddress(depthMap, .readOnly)
            
            let width = CVPixelBufferGetWidth(depthMap)
            let height = CVPixelBufferGetHeight(depthMap)
            
            guard let base = CVPixelBufferGetBaseAddress(depthMap) else {
                CVPixelBufferUnlockBaseAddress(depthMap, .readOnly)
                return
            }
            
            let buffer = base.assumingMemoryBound(to: Float32.self)
            
            let centerX = width / 2
            let centerY = height / 2
            let boxSize = 20
            
            var sum: Float = 0
            var count: Float = 0
            
            for y in (centerY - boxSize)...(centerY + boxSize) {
                for x in (centerX - boxSize)...(centerX + boxSize) {
                    
                    let index = y * width + x
                    let value = buffer[index]
                    
                    if value.isFinite && value > 0.05 && value < 8 {
                        sum += value
                        count += 1
                    }
                }
            }
            
            CVPixelBufferUnlockBaseAddress(depthMap, .readOnly)
            
            guard count > 0 else { return }
            
            let average = sum / count
            
            // 이동 평균 필터 (부드럽게)
            smoothedDistance = smoothedDistance * 0.8 + average * 0.2
            
            DispatchQueue.main.async {
                self.parent.distance = self.smoothedDistance
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arView.session.delegate = context.coordinator
        
        let config = ARWorldTrackingConfiguration()
        
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth) {
            config.frameSemantics.insert(.sceneDepth)
        }
        
        config.environmentTexturing = .none
        config.planeDetection = []
        
        arView.session.run(config)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}
