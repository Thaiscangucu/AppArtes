//
//  Sheet.swift
//  AppArtes
//
//  Created by Thais Cangucu on 24/04/26.
//

import SwiftUI

struct NewItem: View {
    @Environment(\.dismiss) var dismiss
    var formItems = ["Título", "Descrição", "Artista", "Data de criação"]
    @State private var formData: [String: String] = [:]
    var body: some View {
        NavigationStack{
            VStack{
                Button("novo item"){}
                Form {
                    ForEach(formItems, id: \.self) { item in
                        TextField(item, text: Binding(
                            get: { formData[item, default: ""] },
                            set: { formData[item] = $0 }
                        ))
                    }
                }
                .scrollContentBackground(.hidden) 
                
            }
            .navigationTitle("Novo item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        //Create new item
                    }) {
                        Image(systemName: "checkmark")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                }
            }
        }
    }
}


#Preview {
    NewItem()
}
