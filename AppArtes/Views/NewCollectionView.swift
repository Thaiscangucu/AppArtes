//
//  Sheet.swift
//  AppArtes
//
//  Created by Thais Cangucu on 24/04/26.
//

import SwiftUI
import SwiftData

struct NewCollectionView: View {
    @Environment(\.dismiss) var dismiss
    
    @Environment(\.modelContext) private var context
    
    var formItems = ["Título", "Descrição"]
    @State var formData: [String: String] = [:]
    @State var toggle = false
    

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
                        
                        if !titulo.isEmpty {
                            let novaColecao = Colecao(titulo: titulo)
                            context.insert(novaColecao)
                            dismiss()
                        }
                    }) {
                        Image(systemName: "checkmark")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    // Opcional: Desabilita o botão se o título estiver vazio
                    .disabled(formData["Título", default: ""].isEmpty)
                }
            }
        }
    }
}

#Preview {
    // 4. Atualizamos o preview para não precisar mais passar parâmetros
    NewCollectionView()
        .modelContainer(for: Colecao.self, inMemory: true)
}
