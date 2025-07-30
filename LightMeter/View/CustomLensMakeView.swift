//
//  CustomLensMakeView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/29/25.
//

import SwiftUI

struct CustomLensMakeView: View {
    let lens:Models.Lens?
    @State var id:Int = UserDefaults.standard.loadCustomLens().count
    @State var brand:String = ""
    @State var model:String = ""
    @State var apertureList:[Double] = []
    @State var isCanSave:Bool = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
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
                Text("aperture")
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(apertureList, id:\.self) { aperture in
                            Text(String(format: "%0.1f", aperture))
                        }
                        if !apertureList.isEmpty {
                            Button {
                                apertureList.removeLast()
                            } label: {
                                Image(systemName: "delete.left")
                            }
                        }
                    }
                }
            }
            ApertureMakeView {double in
                apertureList.append(double)
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
            if let lens = lens {
                self.id = lens.id
                self.brand = lens.brand
                self.model = lens.name
                self.apertureList = lens.apertures
            }
        }
        .onChange(of: brand) { newValue in
            checkCanSave()
        }
        .onChange(of: model) { newValue in
            checkCanSave()
        }
        .onChange(of: apertureList) { newValue in
            checkCanSave()
        }
    }
    
    func checkCanSave() {
        isCanSave = !brand.isEmpty && !model.isEmpty && !apertureList.isEmpty
    }
    
    func save() {
        let newlens:Models.Lens = .init(id:id, brand: brand, name: model, apertures: apertureList)
        if let lens = self.lens {
            UserDefaults.standard.removeLens(lens: lens)
        }
        UserDefaults.standard.addLens(lens: newlens)
        dismiss()
    }
}

#Preview {
    CustomLensMakeView(lens:nil)
}
