import SwiftUI
import SwiftData

struct CollectionView: View {
    @Bindable var colecao: Colecao

    @State private var isShowingSheet = false
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
                }
                .padding(.horizontal)
                .padding(.top)
            }
        }
        .navigationTitle(colecao.titulo)
        .id(colecao.obras.count)
        .sheet(isPresented: $isShowingSheet) {
            NewItem(colecao: colecao)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isShowingSheet.toggle()
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .semibold))
                        .frame(width: 44, height: 44)
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

private struct ObraColecaoCard: View {
    let obra: ObraDeArte

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let imageData = obra.image, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            if let preco = obra.preco {
                Text(preco, format: .currency(code: "BRL"))
                    .font(.system(size: 13, weight: .bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
            }
        }
        .background(obra.preco != nil ? Color(white: 0.97) : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: obra.preco != nil ? .black.opacity(0.07) : .clear, radius: 5, x: 0, y: 3)
    }
}
