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
    let artista: String
    let quantidadeObras: Int
    let precoTotal: Double
    let imageURL: String
}

// MARK: - Mock Data

private let mockObras: [MockArtwork] = [
    MockArtwork(
        titulo: "A Noite Estrelada",
        artista: "Vincent van Gogh",
        colecao: "Pós-Impressionismo",
        preco: 1_200,
        imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ea/Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg/600px-Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg"
    ),
    MockArtwork(
        titulo: "Moça com Brinco de Pérola",
        artista: "Johannes Vermeer",
        colecao: "Mestres Holandeses",
        preco: 950,
        imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0f/1665_Girl_with_a_Pearl_Earring.jpg/400px-1665_Girl_with_a_Pearl_Earring.jpg"
    ),
    MockArtwork(
        titulo: "O Grito",
        artista: "Edvard Munch",
        colecao: "Expressionismo",
        preco: 870,
        imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Edvard_Munch%2C_1893%2C_The_Scream%2C_oil%2C_tempera_and_pastel_on_cardboard%2C_91_x_73_cm%2C_National_Gallery_of_Norway.jpg/400px-Edvard_Munch%2C_1893%2C_The_Scream%2C_oil%2C_tempera_and_pastel_on_cardboard%2C_91_x_73_cm%2C_National_Gallery_of_Norway.jpg"
    ),
    MockArtwork(
        titulo: "Nenúfares",
        artista: "Claude Monet",
        colecao: "Impressionismo Francês",
        preco: 1_100,
        imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/a/aa/Claude_Monet_-_Water_Lilies_-_1906%2C_Ryerson.jpg/600px-Claude_Monet_-_Water_Lilies_-_1906%2C_Ryerson.jpg"
    ),
    MockArtwork(
        titulo: "A Persistência da Memória",
        artista: "Salvador Dalí",
        colecao: "Surrealismo",
        preco: 2_300,
        imageURL: "https://upload.wikimedia.org/wikipedia/en/d/dd/The_Persistence_of_Memory.jpg"
    ),
    MockArtwork(
        titulo: "O Nascimento de Vênus",
        artista: "Sandro Botticelli",
        colecao: "Renascimento Italiano",
        preco: 3_500,
        imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/2/26/Sandro_Botticelli_-_La_nascita_di_Venere_-_Google_Art_Project_-_edited.jpg/600px-Sandro_Botticelli_-_La_nascita_di_Venere_-_Google_Art_Project_-_edited.jpg"
    ),
]

private let mockColecoes: [MockColecao] = [
    MockColecao(
        titulo: "Impressionismo Francês",
        artista: "Claude Monet",
        quantidadeObras: 8,
        precoTotal: 4_500,
        imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/a/aa/Claude_Monet_-_Water_Lilies_-_1906%2C_Ryerson.jpg/600px-Claude_Monet_-_Water_Lilies_-_1906%2C_Ryerson.jpg"
    ),
    MockColecao(
        titulo: "Pós-Impressionismo",
        artista: "Vincent van Gogh",
        quantidadeObras: 12,
        precoTotal: 8_900,
        imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ea/Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg/600px-Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg"
    ),
    MockColecao(
        titulo: "Surrealismo",
        artista: "Salvador Dalí",
        quantidadeObras: 6,
        precoTotal: 12_000,
        imageURL: "https://upload.wikimedia.org/wikipedia/en/d/dd/The_Persistence_of_Memory.jpg"
    ),
    MockColecao(
        titulo: "Renascimento Italiano",
        artista: "Sandro Botticelli",
        quantidadeObras: 5,
        precoTotal: 15_200,
        imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/2/26/Sandro_Botticelli_-_La_nascita_di_Venere_-_Google_Art_Project_-_edited.jpg/600px-Sandro_Botticelli_-_La_nascita_di_Venere_-_Google_Art_Project_-_edited.jpg"
    ),
]

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
                        ColecaoDestaqueCard(colecao: colecao)
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

            WaterfallGrid(data: mockObras, columns: 2, spacing: 12) { obra in
                ObraMarketCard(obra: obra)
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Collection Card

private struct ColecaoDestaqueCard: View {
    let colecao: MockColecao

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            AsyncImage(url: URL(string: colecao.imageURL)) { phase in
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

private struct ObraMarketCard: View {
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
