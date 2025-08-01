//
//  BodyListView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/24/25.
//

import SwiftUI

struct BodyListView: View {
    @State var list: [Models.Body] = []
    @State var customList : [Models.Body] = []
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
            if customList.count > 0 {
                Section("custom body list") {
                    ForEach(0..<customList.count, id:\.self) { idx in
                        let lens = customList[idx]
                        HStack {
                            Text(String(format:"%d", idx + 1))
                            Button {
                                bodySelectIdx = list.count + idx
                            } label: {
                                HStack {
                                    Text(lens.brand)
                                    Text(lens.name)
                                }
                            }
                            .foregroundStyle(list.count + idx == bodySelectIdx ? .accent : .primary)
                            .swipeActions {
                                makeEditBtn(idx: idx)
                                makeDeleteBtn(idx: idx)
                            }
                        }

                    }
                }
            }
            NavigationLink {
                CustomBodyMakeView(bodyData: nil)
            } label: {
                Text("make custom body")
            }
        }
        .navigationTitle("select body")
        .onAppear {
            list = Models.Body.loadBodyData()
            customList = UserDefaults.standard.loadCustomBodys()
        }
        .onChange(of: bodySelectIdx) {  newValue in
            NotificationCenter.default.post(name: .lightMetterSettingChanged, object: nil)
        }
    }
    
    func makeDeleteBtn(idx:Int)-> some View {
        Button {
            let body = customList[idx]
            UserDefaults.standard.removeBody(body: body)
            customList.remove(at: idx)
        } label : {
            Image(systemName: "trash")
        }
    }
    
    func makeEditBtn(idx:Int)-> some View {
        NavigationLink {
            let body = customList[idx]
            CustomBodyMakeView(bodyData:body)
        } label: {
            Image(systemName: "pencil")
        }
    
    }
}

#Preview {
    BodyListView()
}
