//
//  ShuterSpeedMakeView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/30/25.
//

import SwiftUI

struct ShuterSpeedMakeView: View {
    @State var second:String = "1"
    @State var devine:String = "1"
    
    let onConfirm:(String)->Void
    
    func buttonImage(name:String)-> some View {
        Image(systemName: name)
            .resizable()
            .scaledToFit()
            .frame(width: 30, height: 30)
    }
    
    var secondBtn : some View {
        VStack {
            Button {
                let value = NSString(string: second).intValue + 1
                second = String(format: "%d", value)
            } label: {
                buttonImage(name: "arrowtriangle.up")
            }
            TextField("", text: $second)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
            Button {
                var value = NSString(string: second).intValue - 1
                if value < 1 {
                    value = 1
                }
                second = String(format: "%d", value)
            } label: {
                buttonImage(name: "arrowtriangle.down")
            }

        }
    }
    
    var devineBtn : some View {
        VStack {
            Button {
                let value = NSString(string: devine).intValue + 1
                devine = String(format: "%d", value)
            } label: {
                buttonImage(name: "arrowtriangle.up")
            }
            TextField("", text: $devine)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
            Button {
                var value = NSString(string: devine).intValue - 1
                if value < 1 {
                    value = 1
                }
                devine = String(format: "%d", value)
            } label: {
                buttonImage(name: "arrowtriangle.down")
            }
        }
    }

    
    var body: some View {
        HStack {
            secondBtn
            Text("/")
            devineBtn
            
            Button {
                if second == "0" || devine == "0" {
                    return
                }
                if second != "1" {
                    onConfirm(second)
                    return
                }
                if second == "1" && devine != "1" {
                    onConfirm("1")
                    return
                }
                onConfirm(String(format: "%@/%@", second, devine))
            } label: {
                buttonImage(name: "return")
            }

            Spacer()
        }
        .padding(10)
        .onChange(of: second) { newValue in
            if newValue != "1" {
                devine = "1"
            }
        }
    }
}

#Preview {
    ShuterSpeedMakeView { str in
        Log.debug(str)
    }
}
