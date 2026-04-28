//
//  Sheet.swift
//  AppArtes
//
//  Created by Thais Cangucu on 24/04/26.
//

import SwiftUI

struct NewCollectionView: View {
    @Environment(\.dismiss) var dismiss
    var formItems = ["Título", "Descrição"]
    @State var formData: [String: String] = [:]
    @State var toggle = false
    @Binding var collections: [String]
    
    var body: some View {
        NavigationStack{
            VStack{
                Image("newCollection")
                    .resizable()
                    .frame(width: 217, height: 129)
                    .foregroundStyle(.gray)
                Form {
                    ForEach(formItems, id: \.self) { item in
                        TextField(item, text: Binding(
                            get: { formData[item, default: ""] },
                            set: { formData[item] = $0 }
                        ))
                    }
                    Toggle("Tornar coleção pública", isOn: $toggle)
                }
                .scrollContentBackground(.hidden) 
                
            }
            .navigationTitle("Nova coleção")
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
                            let titulo = formData["Título", default: ""]
                            let descricao = formData["Descrição", default: ""]
                            
                            if !titulo.isEmpty {
                                collections.append(titulo)
                            }
                        dismiss()
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
    NewCollectionView(collections: .constant(["collection"]))
}
