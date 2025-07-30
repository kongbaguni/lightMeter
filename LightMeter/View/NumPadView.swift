//
//  NumPadView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/29/25.
//

import SwiftUI

struct NumPadView: View {
    let confirm:(Double)->()
    
    @State var str: String = ""
    let numbers:[[AnyHashable]] = [[7,8,9],[4,5,6],[1,2,3],[0,".","D"]]
    
    func makeBtn(_ value:AnyHashable)-> some View {
        Button {
            processBtn(value: value)
        } label: {
            Text("\(value)")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.primary)
                .frame(width: 60, height: 60)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.secondary)
                }
        }
    }
    
    var body: some View {
        VStack {
            Text(str)
            ForEach(numbers, id: \.self) { row in
                HStack {
                    ForEach(row, id: \.self) { num in
                        makeBtn(num)
                    }
                }
            }
            Button {
                confirm(NSString(string: str).doubleValue)
                str = ""
            } label: {
                Text("Confirm")
            }
        }
    }
    
    func processBtn(value:AnyHashable) {
        if value is Int {
           str += "\(value)"
        }
        switch value as? String {
        case ".":
            if str.contains(".") == false {
                str.append(".")
            }
        case "D":
            if str.isEmpty {
               return
            }
            _ = str.removeLast()

        default:
            break
        }
    }
}

#Preview {
    NumPadView { double in
        print(double)
        
    }
}
