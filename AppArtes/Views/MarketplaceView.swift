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
        MockArtwork(titulo: "A Noite Estrelada", artista: "Vincent van Gogh", colecao: "Pós-Impressionismo", preco: 1_200, imageName: "mock_starry_night", descricao: "Uma das obras mais reconhecidas do mundo, representando uma noite turbulenta com redemoinhos no céu sobre uma aldeia adormecida de Saint-Rémy-de-Provence.", ano: 1889, dimensoes: "73,7 × 92,1 cm"),
        MockArtwork(titulo: "Autorretrato", artista: "Vincent van Gogh", colecao: "Pós-Impressionismo", preco: 980, imageName: "mock_vangogh_portrait", descricao: "Um dos mais de trinta autorretratos pintados por Van Gogh, revelando sua intensidade emocional e domínio da pincelada expressiva.", ano: 1889, dimensoes: "65 × 54 cm"),
        MockArtwork(titulo: "O Grito", artista: "Edvard Munch", colecao: "Pós-Impressionismo", preco: 870, imageName: "mock_the_scream", descricao: "Ícone da arte expressionista, a figura agonizante em primeiro plano contra um céu turbulento tornou-se símbolo universal da ansiedade humana.", ano: 1893, dimensoes: "91 × 73,5 cm"),
    ]
)

private let colecaoMestresClassicos = MockColecao(
    titulo: "Mestres Clássicos",
    descricao: "Obras icônicas do Renascimento e do Barroco, marcas eternas da pintura ocidental.",
    obras: [
        MockArtwork(titulo: "Mona Lisa", artista: "Leonardo da Vinci", colecao: "Mestres Clássicos", preco: 3_200, imageName: "mock_mona_lisa", descricao: "O retrato mais famoso do mundo, célebre pelo sorriso enigmático e pela técnica sfumato que confere profundidade e suavidade inigualáveis.", ano: 1517, dimensoes: "77 × 53 cm"),
        MockArtwork(titulo: "Las Meninas", artista: "Diego Velázquez", colecao: "Mestres Clássicos", preco: 2_800, imageName: "mock_las_meninas", descricao: "Obra-prima do Barroco espanhol que desafia convenções ao incluir o próprio artista na cena, criando um jogo complexo entre observador e observado.", ano: 1656, dimensoes: "318 × 276 cm"),
        MockArtwork(titulo: "Moça com Brinco de Pérola", artista: "Johannes Vermeer", colecao: "Mestres Clássicos", preco: 950, imageName: "mock_pearl_earring", descricao: "Frequentemente chamada de 'Mona Lisa do Norte', a obra hipnotiza pelo olhar da jovem modelo e pelo brilho luminoso do brinco de pérola.", ano: 1665, dimensoes: "44,5 × 39 cm"),
    ]
)

private let colecaoImpressionsimo = MockColecao(
    titulo: "Impressionismo Francês",
    descricao: "A captura da luz e do instante, revolucionando a pintura europeia no século XIX.",
    obras: [
        MockArtwork(titulo: "Nenúfares", artista: "Claude Monet", colecao: "Impressionismo Francês", preco: 1_100, imageName: "mock_water_lilies", descricao: "Parte de uma série de 250 pinturas dedicadas ao jardim aquático de Monet em Giverny, esta obra é um dos exemplos mais sublimes do Impressionismo tardio.", ano: 1906, dimensoes: "87,6 × 92,7 cm"),
    ]
)

private let colecaoSurrealismo = MockColecao(
    titulo: "Surrealismo",
    descricao: "Arte do inconsciente e dos sonhos, desafiando a lógica e a percepção da realidade.",
    obras: [
        MockArtwork(titulo: "A Persistência da Memória", artista: "Salvador Dalí", colecao: "Surrealismo", preco: 2_300, imageName: "mock_persistence", descricao: "Os relógios derretidos sobre uma paisagem desértica tornaram-se o símbolo máximo do Surrealismo, evocando a natureza fluida e irracional do tempo nos sonhos.", ano: 1931, dimensoes: "24,1 × 33 cm"),
        MockArtwork(titulo: "Guernica", artista: "Pablo Picasso", colecao: "Surrealismo", preco: 4_100, imageName: "mock_guernica", descricao: "Resposta pictórica ao bombardeio nazista da cidade basca de Guernica durante a Guerra Civil Espanhola, é um dos mais poderosos manifestos antibélicos da história da arte.", ano: 1937, dimensoes: "349 × 776 cm"),
    ]
)

private let mockColecoes: [MockColecao] = [
    colecaoPosImpressionsimo, colecaoMestresClassicos, colecaoImpressionsimo, colecaoSurrealismo,
]

private let mockObrasDestaque: [MockArtwork] = mockColecoes.flatMap(\.obras)

// MARK: - Main View

struct MarketplaceView: View {
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    colecoeSection
                    obrasSection
                }
                .padding(.vertical)
            }
            .background(Color.obskaPaper)
            .navigationTitle("Leilão")
        }
    }

    private var colecoeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Coleções em Destaque")
                .font(.fraunces(24))
                .tracking(-0.4)
                .foregroundStyle(Color.obskaInk)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
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
                .font(.fraunces(24))
                .tracking(-0.4)
                .foregroundStyle(Color.obskaInk)
                .padding(.horizontal)

            WaterfallGrid(data: mockObrasDestaque, columns: 2, spacing: 10) { obra in
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
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(colecao.descricao)
                        .font(.system(size: 15))
                        .lineSpacing(4)
                        .foregroundStyle(Color.obskaInk2)

                    HStack {
                        Label("\(colecao.quantidadeObras) obras", systemImage: "photo.stack")
                            .foregroundStyle(Color.obskaInk2)
                        Spacer()
                        Text(colecao.precoTotal, format: .currency(code: "BRL"))
                            .font(.fraunces(20, weight: .medium))
                            .foregroundStyle(Color.obskaInk)
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal)

                Divider().background(Color.obskaHair)

                WaterfallGrid(data: colecao.obras, columns: 2, spacing: 10) { obra in
                    NavigationLink(destination: MarketplaceObraDetalheView(obra: obra)) {
                        ObraMarketCard(obra: obra)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color.obskaPaper)
        .navigationTitle(colecao.titulo)
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Collection Featured Card

private struct ColecaoDestaqueCard: View {
    let colecao: MockColecao

    var body: some View {
        ZStack(alignment: .bottom) {
            // Cover image
            Group {
                if UIImage(named: colecao.coverImageName) != nil {
                    Image(colecao.coverImageName)
                        .resizable()
                        .scaledToFill()
                } else {
                    Rectangle().fill(Color.obskaInk)
                }
            }
            .frame(width: 200, height: 160)
            .clipped()

            // Gradient overlay
            LinearGradient(
                colors: [.clear, .black.opacity(0.75)],
                startPoint: .center, endPoint: .bottom
            )

            // Eyebrow top-left
            VStack {
                HStack {
                    Text("\(String(format: "%02d", colecao.obras.count)) OBRAS")
                        .font(.obskaMonoCaption(9))
                        .tracking(1.4)
                        .foregroundStyle(.white.opacity(0.75))
                    Spacer()
                }
                Spacer()
            }
            .padding(10)

            // Title + total bottom
            VStack(alignment: .leading, spacing: 3) {
                Text(colecao.titulo)
                    .font(.fraunces(16))
                    .tracking(-0.2)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                HStack {
                    Text("TOTAL")
                        .font(.obskaMonoCaption(9))
                        .tracking(0.6)
                        .foregroundStyle(.white.opacity(0.65))
                    Spacer()
                    Text(colecao.precoTotal, format: .currency(code: "BRL"))
                        .font(.obskaMonoCaption(10))
                        .foregroundStyle(.white)
                }
            }
            .padding(10)
        }
        .frame(width: 200, height: 160)
        .clipShape(RoundedRectangle(cornerRadius: Obska.radiusCard))
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Artwork Market Card

struct ObraMarketCard: View {
    let obra: MockArtwork

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Group {
                if UIImage(named: obra.imageName) != nil {
                    Image(obra.imageName)
                        .resizable()
                        .scaledToFit()
                } else {
                    Rectangle()
                        .fill(Color.obskaElevated)
                        .aspectRatio(4/3, contentMode: .fit)
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundStyle(Color.obskaHair)
                        )
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 120)
            .clipShape(RoundedRectangle(cornerRadius: Obska.radiusCard))

            VStack(alignment: .leading, spacing: 4) {
                Text(obra.titulo)
                    .font(.fraunces(15))
                    .tracking(-0.2)
                    .foregroundStyle(Color.obskaInk)
                    .lineLimit(2)

                Text("\(obra.artista) · \(obra.ano)")
                    .font(.system(size: 11))
                    .foregroundStyle(Color.obskaInk2)
                    .lineLimit(1)

                Divider()
                    .background(Color.obskaHair)
                    .padding(.top, 4)

                Text(obra.preco, format: .currency(code: "BRL"))
                    .font(.fraunces(13, weight: .medium))
                    .foregroundStyle(Color.obskaAccent)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 10)
        }
        .background(Color.obskaElevated)
        .overlay(
            RoundedRectangle(cornerRadius: Obska.radiusCard)
                .stroke(Color.obskaHair, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: Obska.radiusCard))
    }
}

#Preview {
    MarketplaceView()
}
