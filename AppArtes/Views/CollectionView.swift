import SwiftUI
import SwiftData

struct CollectionView: View {
    // Recebe a coleção específica da tela anterior
    @Bindable var colecao: Colecao
    
    @State private var isShowingSheet = false
    @Environment(\.modelContext) private var context
    @Query(sort: \ObraDeArte.dataCriacao, order: .reverse) private var obras: [ObraDeArte]
    let numberOfColumns = 2
    let gridSpacing: CGFloat = 12

    var body: some View {
        NavigationStack {
            ScrollView {
                // Usando colecao.obras em vez do antigo @Query
                if colecao.obras.isEmpty {
                    ContentUnavailableView(
                        "Nenhuma Obra",
                        systemImage: "photo.on.rectangle",
                        description: Text("Toque no + para adicionar arte a esta coleção.")
                    )
                    .padding(.top, 50)
                } else {
                    WaterfallGrid(data: obras, columns: numberOfColumns, spacing: gridSpacing) { item in
                        // NavigationLink agora envolve a imagem da obra
                        NavigationLink(destination: DetalheObraView(obra: item)) {
                            if let imageData = item.image, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                            }
                        }
                        .buttonStyle(PlainButtonStyle()) // Essencial para não aplicar cor azul de link na imagem
                    }
                    .padding(.horizontal)
                    .padding(.top)
                }
            }
            .navigationTitle(colecao.titulo) // Título dinâmico da coleção
            .id(colecao.obras.count)
            .sheet(isPresented: $isShowingSheet) {
                // Passamos a coleção para a tela de criação
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
}
