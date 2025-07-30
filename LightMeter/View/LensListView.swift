//
//  LensListView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/24/25.
//

import SwiftUI

struct LensListView: View {
    @State var list: [Models.Lens] = []
    @State var customList : [Models.Lens] = []
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
            if customList.count > 0 {
                Section("custom lens list") {
                    ForEach(0..<customList.count, id:\.self) { idx in
                        let lens = customList[idx]
                        HStack {
                            Text(String(format:"%02d", idx))
                            Button {
                                lensSelectIdx = list.count + idx
                            } label: {
                                HStack {
                                    Text(lens.brand)
                                    Text(lens.name)
                                }
                            }
                            .foregroundStyle(list.count + idx == lensSelectIdx ? .accent : .primary)
                            .swipeActions {
                                makeEditBtn(idx: idx)
                                makeDeleteBtn(idx: idx)
                            }
                        }

                    }
                }
            }
            NavigationLink {
                CustomLensMakeView(lens: nil)
            } label: {
                Text("make custom lens")
            }
        }
        .navigationTitle("select lens")
        .onAppear {
            list = Models.Lens.loadData()
            customList = UserDefaults.standard.loadCustomLens()
        }
        .onChange(of: lensSelectIdx) {  newValue in
            NotificationCenter.default.post(name: .lightMetterSettingChanged, object: nil)
        }
    }
    
    func makeDeleteBtn(idx:Int)-> some View {
        Button {
            let lens = customList[idx]
            UserDefaults.standard.removeLens(lens: lens)
            customList.remove(at: idx)
        } label : {
            Image(systemName: "trash")
        }
    }
    
    func makeEditBtn(idx:Int)-> some View {
        NavigationLink {
            let lens = customList[idx]
            CustomLensMakeView(lens: lens)
        } label: {
            Image(systemName: "pencil")
        }
    
    }
}

#Preview {
    LensListView()
}
