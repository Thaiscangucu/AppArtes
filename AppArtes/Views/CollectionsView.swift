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
                    NavigationLink(destination: CollectionView(colecao: colecao)) {
                        ColecaoCard(colecao: colecao)
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            context.delete(colecao)
                        } label: {
                            Label("Deletar", systemImage: "trash")
                        }
                    }
                }
            }
            .listStyle(.plain)
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
                        Image(systemName: "plus").foregroundStyle(.primary)
                    }
                }
            }
            .sheet(isPresented: $isShowingSheet) {
                NewCollectionView()
            }
        }
    }
}

private struct ColecaoCard: View {
    let colecao: Colecao

    private var coverImage: UIImage? {
        colecao.obras.compactMap { $0.image.flatMap(UIImage.init) }.first
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Group {
                if let uiImage = coverImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color(.systemGray4), Color(.systemGray2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay {
                            Image(systemName: "photo.artframe")
                                .font(.system(size: 40))
                                .foregroundStyle(.white.opacity(0.4))
                        }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 200)
            .clipped()

            LinearGradient(
                colors: [.clear, .black.opacity(0.75)],
                startPoint: .center,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 4) {
                Text(colecao.titulo)
                    .font(.title2).bold()
                    .foregroundStyle(.white)
                Text("\(colecao.obras.count) \(colecao.obras.count == 1 ? "obra" : "obras")")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.75))
            }
            .padding(16)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}
