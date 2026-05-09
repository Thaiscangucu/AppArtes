//
//  HomeView.swift
//  AppArtes
//
//  Created by Thais Cangucu on 24/04/26.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var context
    
    // 1. Busca todas as obras de arte existentes no SwiftData
    @Query(sort: \ObraDeArte.dataCriacao, order: .reverse) private var todasAsObras: [ObraDeArte]
    
    let numberOfColumns = 2
    let gridSpacing: CGFloat = 12
    
    var body: some View {
        NavigationStack {
            ScrollView {
                // 2. Verifica se existem obras para exibir
                if todasAsObras.isEmpty {
                    ContentUnavailableView(
                        "Nenhuma Obra",
                        systemImage: "photo.on.rectangle",
                        description: Text("Suas obras aparecerão aqui assim que você adicioná-las a uma coleção.")
                    )
                    .padding(.top, 50)
                } else {
                    // 3. Reutiliza o WaterfallGrid para mostrar tudo no estilo Pinterest
                    WaterfallGrid(data: todasAsObras, columns: numberOfColumns, spacing: gridSpacing) { item in
                        if let imageData = item.image, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                }
            }
            .navigationTitle("Início") // Alterado para diferenciar da tela de Coleções específicas
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        Text("Configurações em breve")
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [ObraDeArte.self, Colecao.self], inMemory: true)
}
