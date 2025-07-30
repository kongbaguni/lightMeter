//
//  ApertureMakeView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/30/25.
//

import SwiftUI

struct ApertureMakeView: View {
    let onCommit:(Double)->Void

    @State var data:[Int] = [0,0,0]
    
    func buttonImage(name:String)-> some View {
        Image(systemName: name)
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 40)
    }
    
    func numberView(_ idx:Int)-> some View {
        VStack {
            Button {
                data[idx] += 1
                if data[idx] > 9 {
                    data[idx] = 0
                }
            } label: {
                buttonImage(name: "arrowtriangle.up")
            }
            Text("\(data[idx])")
                .font(.system(size: 40, weight: .bold))
            Button {
                data[idx] -= 1
                if data[idx] < 0 {
                    data[idx] = 9
                }
            } label: {
                buttonImage(name: "arrowtriangle.down")
            }
        }
    }
    var body: some View {
        HStack {
            ForEach(0..<data.count, id:\.self) { idx in
                if idx == data.count - 1 {
                    Text(".")
                        .font(.system(size: 40, weight: .bold))
                }
                numberView(idx)
            }
            Button {
                let str = data.map { v in
                    return String(format: "%d", v)
                }.joined()
                let double = NSString(string: str).doubleValue / 10
                onCommit(double)
            } label: {
                buttonImage(name: "return")
            }
        }
    }
}


#Preview {
    ApertureMakeView { double in
        Log.debug("result", double)
    }
}
