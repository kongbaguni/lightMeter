//
//  LensListView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/24/25.
//

import SwiftUI

struct LensListView: View {
    @State var list: [Models.Lens] = []
    @AppStorage("lensSelectIdx") var lensSelectIdx: Int = 0
    
    var body: some View {
        List {
            Section("lens list") {
                ForEach(0..<list.count, id:\.self) { idx in
                    let lens = list[idx]
                    Button {
                        lensSelectIdx = idx
                    } label: {
                        HStack {
                            Text(lens.brand)
                            Text(lens.name)
                        }
                    }
                    .foregroundStyle(idx == lensSelectIdx ? .accent : .primary)
                    
                    
                }
            }
        }
        .navigationTitle("select lens")
        .onAppear {
            list = Models.Lens.loadData()
        }
        .onChange(of: lensSelectIdx) {  newValue in
            NotificationCenter.default.post(name: .lightMetterSettingChanged, object: nil)
        }
    }
}

#Preview {
    LensListView()
}
