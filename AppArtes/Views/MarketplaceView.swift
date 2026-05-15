import SwiftUI

// MARK: - Mock Models

struct MockArtwork: Identifiable {
    let id = UUID()
    let titulo: String
    let artista: String
    let colecao: String
    let preco: Double
    let imageURL: String
}

struct MockColecao: Identifiable {
    let id = UUID()
    let titulo: String
    let descricao: String
    let obras: [MockArtwork]

    var quantidadeObras: Int { obras.count }
    var precoTotal: Double { obras.reduce(0) { $0 + $1.preco } }
    var coverImageURL: String { obras.first?.imageURL ?? "" }
    var artista: String { obras.first?.artista ?? "" }
}

// MARK: - Mock Data

private let colecaoPosImpressionsimo = MockColecao(
    titulo: "Pós-Impressionismo",
    descricao: "Obras que expandiram os limites do Impressionismo, explorando emoção, estrutura e simbolismo.",
    obras: [
        MockArtwork(
            titulo: "A Noite Estrelada",
            artista: "Vincent van Gogh",
            colecao: "Pós-Impressionismo",
            preco: 1_200,
            imageURL: "https://upload.wikimedia.org/wikipedia/commons/e/ea/Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg"
        ),
        MockArtwork(
            titulo: "Autorretrato",
            artista: "Vincent van Gogh",
            colecao: "Pós-Impressionismo",
            preco: 980,
            imageURL: "https://upload.wikimedia.org/wikipedia/commons/b/b2/Vincent_van_Gogh_-_Self-Portrait_-_Google_Art_Project.jpg"
        ),
        MockArtwork(
            titulo: "O Grito",
            artista: "Edvard Munch",
            colecao: "Pós-Impressionismo",
            preco: 870,
            imageURL: "https://upload.wikimedia.org/wikipedia/commons/c/c5/Edvard_Munch%2C_1893%2C_The_Scream%2C_oil%2C_tempera_and_pastel_on_cardboard%2C_91_x_73_cm%2C_National_Gallery_of_Norway.jpg"
        ),
    ]
)

private let colecaoMestresClassicos = MockColecao(
    titulo: "Mestres Clássicos",
    descricao: "Obras icônicas do Renascimento e do Barroco, marcas da história da pintura ocidental.",
    obras: [
        MockArtwork(
            titulo: "Mona Lisa",
            artista: "Leonardo da Vinci",
            colecao: "Mestres Clássicos",
            preco: 3_200,
            imageURL: "https://upload.wikimedia.org/wikipedia/commons/e/ec/Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg"
        ),
        MockArtwork(
            titulo: "Las Meninas",
            artista: "Diego Velázquez",
            colecao: "Mestres Clássicos",
            preco: 2_800,
            imageURL: "https://upload.wikimedia.org/wikipedia/commons/3/31/Las_Meninas%2C_by_Diego_Vel%C3%A1zquez%2C_from_Prado_in_Google_Earth.jpg"
        ),
        MockArtwork(
            titulo: "Moça com Brinco de Pérola",
            artista: "Johannes Vermeer",
            colecao: "Mestres Clássicos",
            preco: 950,
            imageURL: "https://upload.wikimedia.org/wikipedia/commons/0/0f/1665_Girl_with_a_Pearl_Earring.jpg"
        ),
    ]
)

private let colecaoImpressionsimo = MockColecao(
    titulo: "Impressionismo Francês",
    descricao: "A captura da luz e do instante, revolucionando a pintura europeia no século XIX.",
    obras: [
        MockArtwork(
            titulo: "Nenúfares",
            artista: "Claude Monet",
            colecao: "Impressionismo Francês",
            preco: 1_100,
            imageURL: "https://upload.wikimedia.org/wikipedia/commons/a/aa/Claude_Monet_-_Water_Lilies_-_1906%2C_Ryerson.jpg"
        ),
    ]
)

private let colecaoSurrealismo = MockColecao(
    titulo: "Surrealismo",
    descricao: "Arte do inconsciente e dos sonhos, desafiando a lógica e a percepção da realidade.",
    obras: [
        MockArtwork(
            titulo: "A Persistência da Memória",
            artista: "Salvador Dalí",
            colecao: "Surrealismo",
            preco: 2_300,
            imageURL: "https://upload.wikimedia.org/wikipedia/en/d/dd/The_Persistence_of_Memory.jpg"
        ),
        MockArtwork(
            titulo: "Guernica",
            artista: "Pablo Picasso",
            colecao: "Surrealismo",
            preco: 4_100,
            imageURL: "https://upload.wikimedia.org/wikipedia/en/7/74/PicassoGuernica.jpg"
        ),
    ]
)

private let mockColecoes: [MockColecao] = [
    colecaoPosImpressionsimo,
    colecaoMestresClassicos,
    colecaoImpressionsimo,
    colecaoSurrealismo,
]

private let mockObrasDestaque: [MockArtwork] = mockColecoes.flatMap(\.obras)

// MARK: - Main View

struct MarketplaceView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    colecoeSection
                    obrasSection
                }
                .padding(.vertical)
            }
            .navigationTitle("Marketplace")
        }
    }

    private var colecoeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Coleções em Destaque")
                .font(.title2).bold()
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(mockColecoes) { colecao in
                        NavigationLink(destination: MarketplaceColecaoDetalheView(colecao: colecao)) {
                            ColecaoDestaqueCard(colecao: colecao)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 4)
            }
        }
    }

    private var obrasSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Obras à Venda")
                .font(.title2).bold()
                .padding(.horizontal)

            WaterfallGrid(data: mockObrasDestaque, columns: 2, spacing: 12) { obra in
                ObraMarketCard(obra: obra)
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Collection Detail View

struct MarketplaceColecaoDetalheView: View {
    let colecao: MockColecao

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(colecao.descricao)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    HStack {
                        Label("\(colecao.quantidadeObras) obras", systemImage: "photo.stack")
                        Spacer()
                        Text(colecao.precoTotal, format: .currency(code: "BRL"))
                            .font(.title3).bold()
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal)

                Divider()

                WaterfallGrid(data: colecao.obras, columns: 2, spacing: 12) { obra in
                    ObraMarketCard(obra: obra)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle(colecao.titulo)
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Collection Card

private struct ColecaoDestaqueCard: View {
    let colecao: MockColecao

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            AsyncImage(url: URL(string: colecao.coverImageURL)) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                case .failure:
                    Color.gray.opacity(0.3)
                default:
                    Color.gray.opacity(0.15).overlay { ProgressView() }
                }
            }
            .frame(width: 200, height: 130)
            .clipped()

            VStack(alignment: .leading, spacing: 4) {
                Text(colecao.titulo)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                Text(colecao.artista)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                HStack {
                    Text("\(colecao.quantidadeObras) obras")
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(colecao.precoTotal, format: .currency(code: "BRL"))
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(.primary)
                }
            }
            .padding(10)
        }
        .frame(width: 200)
        .background(Color(white: 0.95))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
    }
}

// MARK: - Artwork Card

struct ObraMarketCard: View {
    let obra: MockArtwork

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            AsyncImage(url: URL(string: obra.imageURL)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 0, maxWidth: .infinity)
                case .failure:
                    Color.gray.opacity(0.3).frame(height: 100)
                default:
                    Color.gray.opacity(0.15).frame(height: 100)
                        .overlay { ProgressView() }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 3) {
                Text(obra.titulo)
                    .font(.system(size: 13, weight: .semibold))
                    .lineLimit(2)

                HStack(spacing: 4) {
                    Image(systemName: "photo.artframe")
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                    Text(obra.colecao)
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Text(obra.preco, format: .currency(code: "BRL"))
                    .font(.system(size: 13, weight: .bold))
                    .padding(.top, 2)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
        }
        .background(Color(white: 0.97))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.07), radius: 5, x: 0, y: 3)
    }
}

#Preview {
    MarketplaceView()
}
