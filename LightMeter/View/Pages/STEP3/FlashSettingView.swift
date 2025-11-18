//
//  FlashSettingView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 11/18/25.
//
import SwiftUI
struct FlashSettingView : View {
    @AppStorage("flashGN") var flashGN:Double = 15
    @AppStorage("flashStop") var flashStop:Int = 6
    @AppStorage("flashUseHarfStop") var flashUseHarfStop:Bool = true

    @State var focusIdx:Int? = nil
    var body: some View {
        VStack {
            List {
                Button {
                    focusIdx = 0
                } label: {
                    Text("GN max : \(Int(flashGN))")
                }
                .foregroundStyle(focusIdx == 0 ? .primary : .secondary)
                
                Button {
                    focusIdx = 1
                } label: {
                    Text("Flash stop : \(flashStop)")
                }
                .foregroundStyle(focusIdx == 1 ? .primary : .secondary)
                
                Toggle(isOn: $flashUseHarfStop) {
                    Text("use harfstop")
                }
                
            }
            if focusIdx != nil {
                NumPadView { value in
                    switch focusIdx {
                    case 0:
                        flashGN = value
                    case 1:
                        flashStop = Int(value)
                    default:
                        break
                    }
                }
            }
        }
        .navigationTitle("flash setting")
        
        
    }
}


#Preview {
    FlashSettingView()
}
