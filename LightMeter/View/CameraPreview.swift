//
//  AreaView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/18/25.
//

import SwiftUI

import AVFoundation

struct _CameraPreview: UIViewRepresentable {
    class VideoPreviewView: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }
        
        var previewLayer: AVCaptureVideoPreviewLayer {
            layer as! AVCaptureVideoPreviewLayer
        }
    }
    
    @ObservedObject var manager: LightMeterCameraManager
    
    func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()
        view.previewLayer.session = manager.session
        view.previewLayer.videoGravity = .resizeAspectFill
        return view
    }
    
    func updateUIView(_ uiView: VideoPreviewView, context: Context) {
        // Nothing to update
    }
}

struct CameraPreview : View {
    let manager:LightMeterCameraManager
    var body: some View {
        ZStack {
            _CameraPreview(manager: manager)
        }
        .background {
            RoundedRectangle(cornerRadius: 0)
                .fill(.secondary)
        }
        .background {
            RoundedRectangle(cornerRadius: 0)
                .stroke(lineWidth: 2)
            
        }
        .padding(10)
    }
}


#Preview {
    VStack {
        CameraPreview(manager: .init(lightMeterDidChange: { value in
            
        }))

    }
}
