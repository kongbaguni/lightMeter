//
//  FlashSettingView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 11/18/25.
//
import SwiftUI
struct FlashSettingView : View {
    @AppStorage("flashGN") var flashGN:Double = 15.0
    @AppStorage("flashLevel") var flashLevel:Double = 7.0
    @AppStorage("flashStepInterpolation") var flashStepInterpolation:Int = 0

    @State var flashGNItem:Models.Item = .empty
    @State var flashLevelItem:Models.Item = .empty
    @State var flashStepInterpolationItem:Models.Item = .empty
    
    var flashGNItems : [Models.Item] {
        var result: [Models.Item] = []
        for i in 5...200 {
            result.append(.init(value: Double(i), title: "GN\(i)"))
        }
        return result
    }
    
    var flashLevelItems : [Models.Item] {
        var result: [Models.Item] = []
        for i in 6...10 {
            result.append(.init(value: Double(i), title: "\(i)"))
        }
        return result
    }
    
    var body: some View {
        VStack (alignment: .leading) {
            List {
                VStack (alignment: .leading) {
                    Text("GN max : \(Int(flashGN))")
                    DialView(items: flashGNItems, currentItem: $flashGNItem)
                }
                
                VStack (alignment: .leading) {
                    Text("Flash level : \(Int(flashLevel))")
                    DialView(items: flashLevelItems, currentItem: $flashLevelItem)
                }
               
                VStack (alignment: .leading) {
                    Text("StepInterpolation")
                    DialView(items: Flash.FlashStepInterpolation.items, currentItem: $flashStepInterpolationItem)
                }
            }
        }
        .navigationTitle("flash setting")
        .onAppear(perform: {
            
            for item in flashGNItems {
                if item.value == flashGN {
                    flashGNItem = item
                }
            }
            for item in flashLevelItems {
                if item.value == flashLevel {
                    flashLevelItem = item
                }
            }
            
            for item in Flash.FlashStepInterpolation.items {
                if item.value == Double(flashStepInterpolation) {
                    flashStepInterpolationItem = item
                }
            }
        })
        .onChange(of: flashGNItem, { oldValue, newValue in
            flashGN = newValue.value
            NotificationCenter.default.post(name: .lightMetterStatusDidChanged, object: nil)
        })
        .onChange(of: flashLevelItem, { oldValue, newValue in
            flashLevel = newValue.value
            NotificationCenter.default.post(name: .lightMetterStatusDidChanged, object: nil)
        })
        .onChange(of: flashStepInterpolationItem) { oldValue, newValue in
            flashStepInterpolation = Int(newValue.value)
            NotificationCenter.default.post(name: .lightMetterStatusDidChanged, object: nil)
        }
        
        
    }
}


#Preview {
    FlashSettingView()
}
