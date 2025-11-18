//
//  CameraPermissionView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 11/15/25.
//

import SwiftUI

struct CameraPermissionView: View {
    @Environment(\.openURL) var openURL
    
    var body: some View {
        VStack (alignment: .leading) {
            Image(systemName: "camera")
                .resizable()
                .scaledToFit()
                .padding(50)
            Divider()
            Text("camera permission required title")
                .font(.title)
            Divider()
            Text("camera permission required description")
                .font(.body)
            Divider()
            Button {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    openURL(url)
                }
            } label: {
                Image(systemName: "gear")
                Text("open settings")
                    .font(.headline)
            }
            
        }.padding()
    }
}

#Preview {
    CameraPermissionView()
}
