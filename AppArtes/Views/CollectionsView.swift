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
                    .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
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
            .background(Color.obskaPaper)
            .scrollContentBackground(.hidden)
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
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 32, height: 32)
                            .background(Color.obskaAccent)
                            .clipShape(Circle())
                    }
                }
            }
            .sheet(isPresented: $isShowingSheet) {
                NewCollectionView()
            }
        }
    }
}

// MARK: - Collection Card

private struct ColecaoCard: View {
    let colecao: Colecao

    private var coverImage: UIImage? {
        colecao.obras.compactMap { $0.image.flatMap(UIImage.init) }.first
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            // Background photo or gradient placeholder
            Group {
                if let uiImage = coverImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color.obskaInk2, Color.obskaInk],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 184)
            .clipped()

            // Gradient overlay
            LinearGradient(
                colors: [.clear, .black.opacity(0.8)],
                startPoint: .center, endPoint: .bottom
            )

            // Eyebrow (top-left)
            VStack {
                HStack {
                    Text("\(String(format: "%02d", colecao.obras.count)) OBRAS")
                        .font(.obskaMonoCaption(10))
                        .tracking(1.4)
                        .foregroundStyle(.white.opacity(0.75))
                    Spacer()
                }
                Spacer()
            }
            .padding(14)

            // Title + total (bottom)
            VStack(alignment: .leading, spacing: 4) {
                Text(colecao.titulo)
                    .font(.fraunces(22))
                    .tracking(-0.4)
                    .foregroundStyle(.white)
                    .lineLimit(1)

                HStack {
                    Text("TOTAL")
                        .font(.obskaMonoCaption(10))
                        .tracking(0.8)
                        .foregroundStyle(.white.opacity(0.65))
                    Spacer()
                    if let total = colecaoTotal(colecao) {
                        Text(total, format: .currency(code: "BRL"))
                            .font(.obskaMonoCaption(11))
                            .foregroundStyle(.white)
                    } else {
                        Text("—")
                            .font(.obskaMonoCaption(11))
                            .foregroundStyle(.white.opacity(0.45))
                    }
                }
            }
            .padding(14)
        }
        .clipShape(RoundedRectangle(cornerRadius: Obska.radiusCard))
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
    }

    private func colecaoTotal(_ c: Colecao) -> Double? {
        let precos = c.obras.compactMap(\.preco)
        guard !precos.isEmpty else { return nil }
        return precos.reduce(0, +)
    }
}
