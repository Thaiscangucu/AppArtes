import SwiftUI
import SwiftData

struct CollectionView: View {
    @Bindable var colecao: Colecao

    @State private var showAddSheet = false
    @State private var showEditSheet = false
    @Environment(\.modelContext) private var context

    let numberOfColumns = 2
    let gridSpacing: CGFloat = 10

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
                            Label("Excluir obra", systemImage: "trash")
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top)
            }
        }
        .background(Color.obskaPaper)
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
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 32, height: 32)
                        .background(Color.obskaAccent)
                        .clipShape(Circle())
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                ObskaCircleButton(systemName: "pencil") {
                    showEditSheet.toggle()
                }
            }
        }
    }

    private func removerObra(_ obra: ObraDeArte) {
        colecao.obras.removeAll { $0.id == obra.id }
        context.delete(obra)
    }
}

// MARK: - Artwork Card

private struct ObraColecaoCard: View {
    let obra: ObraDeArte

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Flush photo
            if let imageData = obra.image, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, minHeight: 1)
            }

            // Text area
            VStack(alignment: .leading, spacing: 6) {
                Text(obra.titulo)
                    .font(.fraunces(16))
                    .tracking(-0.2)
                    .foregroundStyle(Color.obskaInk)
                    .lineLimit(2)

                if !obra.descricao.isEmpty {
                    Text(obra.descricao)
                        .font(.system(size: 12))
                        .foregroundStyle(Color.obskaInk2)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                }

                // Footer divider + price
                if let preco = obra.preco {
                    Divider()
                        .background(Color.obskaHair)
                        .padding(.top, 2)

                    Text(preco, format: .currency(code: "BRL"))
                        .font(.fraunces(13, weight: .medium))
                        .foregroundStyle(Color.obskaAccent)
                }
            }
            .padding(10)
        }
        .background(Color.obskaElevated)
        .overlay(
            RoundedRectangle(cornerRadius: Obska.radiusCard)
                .stroke(Color.obskaHair, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: Obska.radiusCard))
    }
}
