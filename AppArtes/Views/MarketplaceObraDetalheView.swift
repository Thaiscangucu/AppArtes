import SwiftUI

// MARK: - Lance Model

struct Lance: Identifiable {
    let id = UUID()
    let valor: Double
    let usuario: String
    let dataHora: Date
}

// MARK: - Detail View

struct MarketplaceObraDetalheView: View {
    let obra: MockArtwork

    @State private var lanceAtual: Double
    @State private var historico: [Lance]
    @State private var showBidSheet = false
    @State private var bidSuccess = false

    init(obra: MockArtwork) {
        self.obra = obra
        let preco = obra.preco
        _lanceAtual = State(initialValue: preco)
        _historico = State(initialValue: [
            Lance(valor: preco * 0.82, usuario: "Pedro A.", dataHora: Date().addingTimeInterval(-7200)),
            Lance(valor: preco * 0.91, usuario: "Ana L.",   dataHora: Date().addingTimeInterval(-3600)),
            Lance(valor: preco,        usuario: "Carlos R.", dataHora: Date().addingTimeInterval(-1800)),
        ])
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                imageSection
                    .padding(.bottom, 20)

                VStack(alignment: .leading, spacing: 20) {
                    titleSection
                    Divider()
                    descricaoSection
                    Divider()
                    bidSection
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showBidSheet) {
            BidSheet(lanceAtual: lanceAtual) { novoLance in
                withAnimation(.spring()) {
                    historico.append(Lance(valor: novoLance, usuario: "Você", dataHora: .now))
                    lanceAtual = novoLance
                    bidSuccess = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation { bidSuccess = false }
                }
            }
        }
        .overlay {
            if bidSuccess {
                BidSuccessOverlay()
                    .transition(.opacity)
            }
        }
    }

    // MARK: - Sections

    private var imageSection: some View {
        Image(obra.imageName)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
    }

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(obra.titulo)
                .font(.title2).bold()
            Text(obra.artista)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Label(obra.colecao, systemImage: "photo.artframe")
                .font(.caption)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.blue.opacity(0.1))
                .foregroundStyle(.blue)
                .clipShape(Capsule())
                .padding(.top, 4)
        }
    }

    private var descricaoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(obra.descricao)
                .font(.body)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                chipDetalhe(icone: "calendar", label: "\(obra.ano)")
                chipDetalhe(icone: "ruler", label: obra.dimensoes)
                chipDetalhe(icone: "paintpalette", label: "Óleo sobre tela")
            }
        }
    }

    private var bidSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Lance Atual")
                .font(.headline)

            Text(lanceAtual, format: .currency(code: "BRL"))
                .font(.system(size: 36, weight: .bold, design: .rounded))

            VStack(spacing: 0) {
                ForEach(historico.reversed()) { lance in
                    lanceRow(lance)
                    if lance.id != historico.first?.id {
                        Divider().padding(.leading, 44)
                    }
                }
            }
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Button {
                showBidSheet = true
            } label: {
                Text("Dar Lance")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.primary)
                    .foregroundStyle(Color(UIColor.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.top, 4)
        }
    }

    private func lanceRow(_ lance: Lance) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(Color(.systemGray5)).frame(width: 32, height: 32)
                Text(String(lance.usuario.prefix(1)))
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.secondary)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(lance.usuario).font(.subheadline).bold()
                Text(lance.dataHora, style: .relative)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(lance.valor, format: .currency(code: "BRL"))
                .font(.subheadline).bold()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
    }

    private func chipDetalhe(icone: String, label: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icone).font(.caption)
            Text(label).font(.caption)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color(.secondarySystemBackground))
        .clipShape(Capsule())
    }
}

// MARK: - Bid Sheet

struct BidSheet: View {
    let lanceAtual: Double
    let onConfirm: (Double) -> Void

    @Environment(\.dismiss) var dismiss
    @State private var lanceTexto = ""
    @State private var erro: String?

    private var lanceMinimo: Double { lanceAtual + 50 }

    var body: some View {
        NavigationStack {
            VStack(spacing: 28) {
                VStack(spacing: 4) {
                    Text("Lance atual")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(lanceAtual, format: .currency(code: "BRL"))
                        .font(.title).bold()
                }
                .padding(.top, 8)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Seu lance — mínimo \(lanceMinimo.formatted(.currency(code: "BRL")))")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    TextField("R$ 0,00", text: $lanceTexto)
                        .keyboardType(.decimalPad)
                        .font(.title2.bold())
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .onChange(of: lanceTexto) { _, _ in erro = nil }

                    if let erro {
                        Text(erro)
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }

                Button {
                    let valor = Double(lanceTexto.replacingOccurrences(of: ",", with: ".")) ?? 0
                    guard valor >= lanceMinimo else {
                        erro = "Lance mínimo: \(lanceMinimo.formatted(.currency(code: "BRL")))"
                        return
                    }
                    onConfirm(valor)
                    dismiss()
                } label: {
                    Text("Confirmar Lance")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(.black)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Dar Lance")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancelar") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Success Overlay

private struct BidSuccessOverlay: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(.green)
            Text("Lance registrado!")
                .font(.title2).bold()
            Text("Você está na frente por enquanto.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial)
    }
}
