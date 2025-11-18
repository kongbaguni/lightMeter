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
            .frame(width: 30, height: 30)
    }
    
    enum DataUpdateVector {
        case up
        case down
    }
    
    func updateDate(idx:Int, vector:DataUpdateVector) {
        switch vector {
        case .up:
            data[idx] += 1
            if data[idx] > 9 {
                data[idx] = 0
                if idx - 1 >= 0 {
                    data[idx - 1] += 1
                }
            }
        case .down:
            data[idx] -= 1
            if data[idx] < 0 {
                data[idx] = 9
                if idx - 1 >= 0 {
                    data[idx - 1] -= 1
                }
            }
        }
        
        for (idx, item) in data.enumerated() {
            if item > 9 {
                data[idx] -= 10
                if idx > 0 {
                    data[idx - 1] += 1
                }
            }
            else if item < 0 {
                data[idx] += 10
                if idx > 0 {
                    data[idx - 1] -= 1
                    if data[idx - 1] < 0 {
                        data[idx - 1] = 0
                    }
                }
            }
        }

    }
    
    
    func numberView(_ idx:Int)-> some View {
        VStack {
            Button {
                updateDate(idx: idx, vector: .up)
            } label: {
                buttonImage(name: "arrowtriangle.up")
            }
            Text("\(data[idx])")
                .font(.system(size: 40, weight: .bold))
            Button {
                updateDate(idx: idx, vector: .down)
            } label: {
                buttonImage(name: "arrowtriangle.down")
            }
        }
    }
    var body: some View {
        HStack {
            Text("F").font(.system(size: 40, design: .serif).italic())
                .padding(5)
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
            Spacer()
            
        }.padding(10)
    }
}


#Preview {
    ApertureMakeView { double in
        Log.debug("result", double)
    }
}
