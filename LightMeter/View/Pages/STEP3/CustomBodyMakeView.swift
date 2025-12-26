//
//  CustomBodyMakeView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/30/25.
//

import SwiftUI

struct CustomBodyMakeView: View {
    let bodyData:Models.Body?
    @State var id:Int = UserDefaults.standard.loadCustomBodys().count
    @State var brand:String = ""
    @State var model:String = ""
    @State var shutterSpeedList:[String] = []
    @State var isCanSave:Bool = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
#if DEBUG
            Text(String(format:"id : %d", id))
#endif 
            HStack {
                Text("Brand")
                TextField(text: $brand) {
                    Text("Brand")
                }
                .textFieldStyle(.roundedBorder)
            }
            HStack {
                Text("Model")
                TextField(text: $model) {
                    Text("Model")
                }
                .textFieldStyle(.roundedBorder)
            }
            HStack {
                Text("shutterSpeed")
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(shutterSpeedList, id:\.self) { speed in
                            Text(speed)
                                .padding(5)
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.blue)
                                }
                                .foregroundStyle(.white)
                        }
                        if !shutterSpeedList.isEmpty {
                            Button {
                                shutterSpeedList.removeLast()
                            } label: {
                                Image(systemName: "delete.left")
                            }
                        }
                    }
                }
            }
            
            ShuterSpeedMakeView { str in
                shutterSpeedList.append(str)
            }

            
        }
        .toolbar {
            Button {
                save()
            } label: {
                Text("save")
            }.disabled(!isCanSave)
        }
        .padding()
        .onAppear {
            if let data = bodyData {
                self.id = data.id
                self.brand = data.brand
                self.model = data.name
                self.shutterSpeedList = data.shutterSpeeds
            }
        }
        .onChange(of: brand) {_,newValue in
            checkCanSave()
        }
        .onChange(of: model) {_,newValue in
            checkCanSave()
        }
        .onChange(of: shutterSpeedList) {_, newValue in
            checkCanSave()
        }
    }
    
    func checkCanSave() {
        isCanSave = !brand.isEmpty && !model.isEmpty && !shutterSpeedList.isEmpty
    }
    
    func save() {        
        let newbody:Models.Body = .init(id:id, brand: brand, name: model, shutterSpeeds: shutterSpeedList)
        if !UserDefaults.standard.editBody(body: newbody) {
            UserDefaults.standard.addBody(body: newbody)
        }
        dismiss()
    }
}

#Preview {
    CustomBodyMakeView(bodyData: nil)
}
