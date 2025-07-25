//
//  BodyListView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/24/25.
//

import SwiftUI

struct BodyListView: View {
    @State var list: [Models.Body] = []
    @AppStorage("bodySelectIdx") var bodySelectIdx: Int = 0
    
    var body: some View {
        List {
            Section("body list") {
                ForEach(0..<list.count, id:\.self) { idx in
                    let body = list[idx]
                    Button {
                        bodySelectIdx = idx
                    } label: {
                        HStack {
                            Text(body.brand)
                            Text(body.name)
                        }
                    }
                    .foregroundStyle(idx == bodySelectIdx ? .accent : .primary)
                    
                    
                }
            }
        }
        .navigationTitle("select body")
        .onAppear {
            list = Models.Body.loadBodyData()
        }
    }
}

#Preview {
    BodyListView()
}
