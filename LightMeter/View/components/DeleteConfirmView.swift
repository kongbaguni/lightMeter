//
//  DeleteConfirmView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 11/19/25.
//

import SwiftUI
struct DeleteConfirmView: View {
    let name:String
    let onConfirm:(Bool) -> Void
    @State var confirmTxt = ""

    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Delete Confirm title")
                .font(.title)
                .foregroundStyle(.primary)
            Text("Delete Confirm msg")
                .font(.headline)
                .foregroundStyle(.secondary)
            HStack {
                Text("name")
                    .font(.body)
                Text(name)
                    .font(.body).bold()
                    .foregroundStyle(.teal)
            }
            TextField(text: $confirmTxt) {
                Text(name)
            }.textFieldStyle(.roundedBorder)
            
            HStack {
                Button {
                    onConfirm(false)
                } label: {
                    Text("cancel")
                        .font(.title2).bold()
                }
                Button {
                    onConfirm(true)
                } label: {
                    Text("delete")
                        .font(.title2).bold()
                }
                .disabled(confirmTxt != name)
            }
        }
        .padding(30)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.black.opacity(0.8))
        }
        .safeGlassEffect(useInteractive: false, inShape: RoundedRectangle(cornerRadius: 20))

        .padding()
    }
}


#Preview {
    DeleteConfirmView(name:"") { isConfirm in
        
    }
}
