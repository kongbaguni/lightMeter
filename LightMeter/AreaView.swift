//
//  AreaView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/18/25.
//

import SwiftUI

struct AreaView: View {
    let size:CGSize
    let area:LightMeterCameraManager.Area
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
            imageView
                .resizable()
                .scaledToFit()
                .frame(width: size.width, height: size.height)
            title
                .background {
                    RoundedRectangle(cornerRadius: 0)
                        .fill(Color.yellow)
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
        AreaView(size: .init(width: 40 * 5, height: 30 * 5), area: .spot)
        
        AreaView(size: .init(width: 40 * 5, height: 30 * 5), area: .center)

        AreaView(size: .init(width: 40 * 5, height: 30 * 5), area: .multi)

    }
}
