//
//  AreaView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/18/25.
//

import SwiftUI

import AVFoundation

struct CameraPreview: UIViewRepresentable {
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

struct AreaView: View {
    let size:CGSize
    let area:LightMeterCameraManager.Area
    @ObservedObject var manager: LightMeterCameraManager
    
    @State var imageView:Image = .init(systemName: "photo")
        
    var centerSize : CGSize {
        area.value.rect(for: .init(origin: .zero, size: size)).size
    }
    
    var title:Text {
        switch area {
        case .center:
            return Text("Center")
        case .spot:
            return Text("Spot")
        case .multi:
            return Text("Multi")
        }
    }
    
    var body: some View {
        ZStack {            
            CameraPreview(manager: manager)
                .frame(width: size.width, height: size.height)
            
                .overlay {
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(Color.yellow, lineWidth: 2)
                        .frame(width: centerSize.width, height: centerSize.height)
                }
                .frame(width: size.width, height: size.height)
                .overlay {
                    RoundedRectangle(cornerRadius: 0)
                        .stroke()
                }
        }
        
    }
}

#Preview {
    VStack {
        AreaView(size: .init(width: 40 * 5, height: 30 * 5), area: .spot, manager: .init(lightMeterDidChange: { value in
            
        }))
        
        AreaView(size: .init(width: 40 * 5, height: 30 * 5), area: .center, manager: .init(lightMeterDidChange: { value in
            
        }))

        AreaView(size: .init(width: 40 * 5, height: 30 * 5), area: .multi, manager: .init(lightMeterDidChange: { value in
            
        }))

    }
}
