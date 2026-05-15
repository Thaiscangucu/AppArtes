//
//  DetalheObraView.swift
//  AppArtes
//
//  Created by Thais Cangucu on 08/05/26.
//


import SwiftUI

struct DetalheObraView: View {
    let obra: ObraDeArte
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                // Nome da Obra no topo
                Text(obra.titulo)
                    .font(.system(size: 24, weight: .bold))
                    .padding(.top)

                // Imagem Principal
                if let imageData = obra.image, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                }

                // Lista de Detalhes (Baseado na sua imagem)
                VStack(alignment: .leading, spacing: 0) {
                    if let preco = obra.preco {
                        detalheLinha(label: "Preço", valor: preco.formatted(.currency(code: "BRL")))
                    }
                    detalheLinha(label: "Pintura", valor: obra.formatoArquivo)
                    detalheLinha(label: "Descrição", valor: obra.descricao)
                    detalheLinha(label: "Data de criação", valor: obra.dataCriacao.formatted(date: .long, time: .omitted))
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .padding(8)
                        .background(Circle().fill(Color(white: 0.95)))
                        .foregroundColor(.black)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button { /* Ações extras */ } label: {
                    Image(systemName: "ellipsis")
                        .padding(8)
                        .background(Circle().fill(Color(white: 0.95)))
                        .foregroundColor(.black)
                }
            }
        }
    }

    // Componente para as linhas de texto com separador
    @ViewBuilder
    private func detalheLinha(label: String, valor: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Divider()
            Text(label)
                .font(.headline)
            Text(valor)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}