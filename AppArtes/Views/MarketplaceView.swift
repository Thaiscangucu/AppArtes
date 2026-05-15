import SwiftUI

// MARK: - Mock Models

struct MockArtwork: Identifiable {
    let id = UUID()
    let titulo: String
    let artista: String
    let colecao: String
    let preco: Double
    let imageName: String
    let descricao: String
    let ano: Int
    let dimensoes: String
}

struct MockColecao: Identifiable {
    let id = UUID()
    let titulo: String
    let descricao: String
    let obras: [MockArtwork]

    var quantidadeObras: Int { obras.count }
    var precoTotal: Double { obras.reduce(0) { $0 + $1.preco } }
    var coverImageName: String { obras.first?.imageName ?? "" }
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
            imageName: "mock_starry_night",
            descricao: "Uma das obras mais reconhecidas do mundo, representando uma noite turbulenta com redemoinhos no céu sobre uma aldeia adormecida de Saint-Rémy-de-Provence.",
            ano: 1889,
            dimensoes: "73,7 × 92,1 cm"
        ),
        MockArtwork(
            titulo: "Autorretrato",
            artista: "Vincent van Gogh",
            colecao: "Pós-Impressionismo",
            preco: 980,
            imageName: "mock_vangogh_portrait",
            descricao: "Um dos mais de trinta autorretratos pintados por Van Gogh, revelando sua intensidade emocional e domínio da pincelada expressiva.",
            ano: 1889,
            dimensoes: "65 × 54 cm"
        ),
        MockArtwork(
            titulo: "O Grito",
            artista: "Edvard Munch",
            colecao: "Pós-Impressionismo",
            preco: 870,
            imageName: "mock_the_scream",
            descricao: "Ícone da arte expressionista, a figura agonizante em primeiro plano contra um céu turbulento tornou-se símbolo universal da ansiedade humana.",
            ano: 1893,
            dimensoes: "91 × 73,5 cm"
        ),
    ]
)

private let colecaoMestresClassicos = MockColecao(
    titulo: "Mestres Clássicos",
    descricao: "Obras icônicas do Renascimento e do Barroco, marcas eternas da pintura ocidental.",
    obras: [
        MockArtwork(
            titulo: "Mona Lisa",
            artista: "Leonardo da Vinci",
            colecao: "Mestres Clássicos",
            preco: 3_200,
            imageName: "mock_mona_lisa",
            descricao: "O retrato mais famoso do mundo, célebre pelo sorriso enigmático e pela técnica sfumato que confere profundidade e suavidade inigualáveis.",
            ano: 1517,
            dimensoes: "77 × 53 cm"
        ),
        MockArtwork(
            titulo: "Las Meninas",
            artista: "Diego Velázquez",
            colecao: "Mestres Clássicos",
            preco: 2_800,
            imageName: "mock_las_meninas",
            descricao: "Obra-prima do Barroco espanhol que desafia convenções ao incluir o próprio artista na cena, criando um jogo complexo entre observador e observado.",
            ano: 1656,
            dimensoes: "318 × 276 cm"
        ),
        MockArtwork(
            titulo: "Moça com Brinco de Pérola",
            artista: "Johannes Vermeer",
            colecao: "Mestres Clássicos",
            preco: 950,
            imageName: "mock_pearl_earring",
            descricao: "Frequentemente chamada de 'Mona Lisa do Norte', a obra hipnotiza pelo olhar da jovem modelo e pelo brilho luminoso do brinco de pérola.",
            ano: 1665,
            dimensoes: "44,5 × 39 cm"
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
            imageName: "mock_water_lilies",
            descricao: "Parte de uma série de 250 pinturas dedicadas ao jardim aquático de Monet em Giverny, esta obra é um dos exemplos mais sublimes do Impressionismo tardio.",
            ano: 1906,
            dimensoes: "87,6 × 92,7 cm"
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
            imageName: "mock_persistence",
            descricao: "Os relógios derretidos sobre uma paisagem desértica tornaram-se o símbolo máximo do Surrealismo, evocando a natureza fluida e irracional do tempo nos sonhos.",
            ano: 1931,
            dimensoes: "24,1 × 33 cm"
        ),
        MockArtwork(
            titulo: "Guernica",
            artista: "Pablo Picasso",
            colecao: "Surrealismo",
            preco: 4_100,
            imageName: "mock_guernica",
            descricao: "Resposta pictórica ao bombardeio nazista da cidade basca de Guernica durante a Guerra Civil Espanhola, é um dos mais poderosos manifestos antibélicos da história da arte.",
            ano: 1937,
            dimensoes: "349 × 776 cm"
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
                NavigationLink(destination: MarketplaceObraDetalheView(obra: obra)) {
                    ObraMarketCard(obra: obra)
                }
                .buttonStyle(PlainButtonStyle())
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
                    NavigationLink(destination: MarketplaceObraDetalheView(obra: obra)) {
                        ObraMarketCard(obra: obra)
                    }
                    .buttonStyle(PlainButtonStyle())
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
            Image(colecao.coverImageName)
                .resizable()
                .scaledToFill()
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
            Image(obra.imageName)
                .resizable()
                .scaledToFit()
                .frame(minWidth: 0, maxWidth: .infinity)
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
