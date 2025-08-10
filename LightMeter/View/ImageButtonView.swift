//
//  ImageButtonView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 8/10/25.
//

import SwiftUI

struct ImageButtonView: View {
    let systemName:String
    let onClick:()->Void
    var body: some View {
        Button {
            onClick()
        } label: {
            ButtonImageView(systemName: systemName)
        }
    }
}

#Preview {
    ImageButtonView(systemName: "gearshape") {
        
    }
}
