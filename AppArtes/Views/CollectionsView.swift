import SwiftUI
import SwiftData

struct CollectionsView: View {
    @State private var isShowingSheet = false
    @Query private var collections: [Colecao]
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(collections) { colecao in
                    ZStack(alignment: .leading) {
                        NavigationLink(destination: CollectionView(colecao: colecao)) {
                            EmptyView()
                        }
                        .opacity(0)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text(colecao.titulo)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                            
                            HStack(spacing: 8) {
                                imageSlot(for: colecao, index: 0, width: 160, height: 160)
                                
                                VStack(spacing: 8) {
                                    imageSlot(for: colecao, index: 1, width: 140, height: 76)
                                    imageSlot(for: colecao, index: 2, width: 140, height: 76)
                                }
                            }
                        }
                        .padding(16)
                        .background(Color(white: 0.88))
                        .clipShape(RoundedRectangle(cornerRadius: 0))
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            deletarColecao(colecao)
                        } label: {
                            Label("Deletar", systemImage: "trash")
                        }
                    }
                }
            }
            .listStyle(.plain)
            // MARK: Mensagem de estado vazio
            .overlay {
                if collections.isEmpty {
                    ContentUnavailableView(
                        "Nenhuma Coleção",
                        systemImage: "folder.badge.plus",
                        description: Text("Toque no + para criar sua primeira coleção.")
                    )
                }
            }
            .navigationTitle("Coleções")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .background(Circle().fill(Color(white: 0.95)).frame(width: 32, height: 32))
                            .foregroundColor(.black)
                    }
                }
            }
            .sheet(isPresented: $isShowingSheet) {
                NewCollectionView()
            }
        }
    }
    
    private func deletarColecao(_ colecao: Colecao) {
        context.delete(colecao)
    }
    
    @ViewBuilder
    private func imageSlot(for colecao: Colecao, index: Int, width: CGFloat, height: CGFloat) -> some View {
        if index < colecao.obras.count,
           let imageData = colecao.obras[index].image,
           let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
                .clipped()
                .background(Color.white)
        } else {
            Rectangle()
                .fill(Color.white)
                .frame(width: width, height: height)
        }
    }
}
