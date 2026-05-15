//
//  HomeView.swift
//  AppArtes
//
//  Created by Thais Cangucu on 24/04/26.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Query(sort: \ObraDeArte.dataCriacao, order: .reverse) private var obras: [ObraDeArte]

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                if obras.isEmpty {
                    ContentUnavailableView(
                        "Nenhuma Obra",
                        systemImage: "photo.on.rectangle",
                        description: Text("Suas obras aparecerão aqui assim que você adicioná-las a uma coleção.")
                    )
                    .padding(.top, 50)
                } else {
                    WaterfallGrid(data: obras, columns: 2, spacing: 3) { item in
                        NavigationLink(destination: DetalheObraView(obra: item)) {
                            if let imageData = item.image, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 1)
                                    .clipShape(RoundedRectangle(cornerRadius: Obska.radiusCard))
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal, 3)
                    .padding(.top, 3)
                }
            }
            .background(Color.obskaPaper)
            .navigationTitle("Obras")
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [ObraDeArte.self, Colecao.self], inMemory: true)
}
