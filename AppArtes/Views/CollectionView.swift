import SwiftUI
import SwiftData

struct CollectionView: View {
    @Bindable var colecao: Colecao

    @State private var showAddSheet = false
    @State private var showEditSheet = false
    @Environment(\.modelContext) private var context

    let numberOfColumns = 2
    let gridSpacing: CGFloat = 12

    var body: some View {
        ScrollView {
            if colecao.obras.isEmpty {
                ContentUnavailableView(
                    "Nenhuma Obra",
                    systemImage: "photo.on.rectangle",
                    description: Text("Toque no + para adicionar arte a esta coleção.")
                )
                .padding(.top, 50)
            } else {
                WaterfallGrid(data: colecao.obras, columns: numberOfColumns, spacing: gridSpacing) { item in
                    NavigationLink(destination: DetalheObraView(obra: item)) {
                        ObraColecaoCard(obra: item)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .contextMenu {
                        Button(role: .destructive) {
                            removerObra(item)
                        } label: {
                            Label("Remover da coleção", systemImage: "trash")
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top)
            }
        }
        .navigationTitle(colecao.titulo)
        .id(colecao.obras.count)
        .sheet(isPresented: $showAddSheet) {
            NewItem(colecao: colecao)
        }
        .sheet(isPresented: $showEditSheet) {
            EditCollectionView(colecao: colecao)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showAddSheet.toggle()
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.blue)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showEditSheet.toggle()
                } label: {
                    Image(systemName: "pencil")
                        .foregroundColor(.primary)
                }
            }
        }
    }

    private func removerObra(_ obra: ObraDeArte) {
        colecao.obras.removeAll { $0.id == obra.id }
        context.delete(obra)
    }
}

// MARK: - Obra Card

private struct ObraColecaoCard: View {
    let obra: ObraDeArte

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let imageData = obra.image, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(obra.titulo)
                    .font(.system(size: 13, weight: .semibold))
                    .lineLimit(1)

                if !obra.descricao.isEmpty {
                    Text(obra.descricao)
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                }

                if let preco = obra.preco {
                    Text(preco, format: .currency(code: "BRL"))
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.secondary)
                        .padding(.top, 2)
                }
            }
            .padding(.horizontal, 6)
            .padding(.top, 8)
            .padding(.bottom, 10)
        }
        .background(Color(white: 0.97))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.07), radius: 4, x: 0, y: 2)
    }
}
