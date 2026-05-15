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
    @Environment(\.dismiss) private var dismiss

    init(obra: MockArtwork) {
        self.obra = obra
        let preco = obra.preco
        _lanceAtual = State(initialValue: preco)
        _historico = State(initialValue: [
            Lance(valor: preco * 0.82, usuario: "Pedro A.",  dataHora: Date().addingTimeInterval(-7200)),
            Lance(valor: preco * 0.91, usuario: "Ana L.",    dataHora: Date().addingTimeInterval(-3600)),
            Lance(valor: preco,        usuario: "Carlos R.", dataHora: Date().addingTimeInterval(-1800)),
        ])
    }

    private var lanceMinimo: Double { lanceAtual + 50 }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    heroSection
                    contentSection
                        .padding(.bottom, 220) // space for sticky CTA
                }
            }
            .ignoresSafeArea(edges: .top)
            .background(Color.obskaPaper)

            stickyCTACard
                .padding(.horizontal, 16)
                .padding(.bottom, 40)
        }
        .navigationBarHidden(true)
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

    // MARK: - Hero

    private var heroSection: some View {
        ZStack(alignment: .bottom) {
            Image(obra.imageName)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 460)
                .clipped()

            // Nav buttons overlay
            VStack {
                HStack {
                    ObskaCircleButton(systemName: "chevron.left", frosted: true) { dismiss() }
                    Spacer()
                    HStack(spacing: 8) {
                        ObskaCircleButton(systemName: "heart", frosted: true) {}
                        ObskaCircleButton(systemName: "ellipsis", frosted: true) {}
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 60)
                Spacer()
            }

            // Lot strip at bottom of image
            HStack {
                Text("LOTE 047 · ENCERRA EM 02:14:09")
                    .font(.obskaMonoCaption(10))
                    .tracking(1.2)
                    .foregroundStyle(.white.opacity(0.8))
                Spacer()
                Text("1 / 4")
                    .font(.obskaMonoCaption(10))
                    .foregroundStyle(.white.opacity(0.55))
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 14)
            .background(
                LinearGradient(colors: [.clear, .black.opacity(0.55)],
                               startPoint: .top, endPoint: .bottom)
                    .frame(height: 60)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            )
        }
        .frame(height: 460)
    }

    // MARK: - Content

    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Title block
            VStack(alignment: .leading, spacing: 4) {
                Text(obra.titulo)
                    .font(.fraunces(32))
                    .tracking(-0.8)
                    .foregroundStyle(Color.obskaInk)

                Text(obra.artista)
                    .font(.frauncesItalic(18))
                    .foregroundStyle(Color.obskaInk2)
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)

            // Collection tag
            HStack(spacing: 6) {
                ObskaMark(size: 10, color: .obskaAccent, accent: .obskaAccent)
                Text(obra.colecao)
                    .font(.system(size: 12, weight: .medium))
            }
            .foregroundStyle(Color.obskaAccent)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .overlay(Capsule().stroke(Color.obskaAccent, lineWidth: 1))
            .padding(.horizontal, 20)
            .padding(.top, 14)

            // Description
            Text(obra.descricao)
                .font(.system(size: 15))
                .lineSpacing(5)
                .foregroundStyle(Color.obskaInk)
                .padding(.horizontal, 20)
                .padding(.top, 20)

            // Spec chips
            HStack(spacing: 8) {
                specChip(label: "ANO", value: "\(obra.ano)")
                specChip(label: "DIM.", value: obra.dimensoes)
                specChip(label: "TÉCNICA", value: "Óleo sobre tela")
            }
            .padding(.horizontal, 20)
            .padding(.top, 18)

            // Bid section
            Divider()
                .background(Color.obskaHair)
                .padding(.horizontal, 20)
                .padding(.top, 28)

            bidSection
                .padding(.horizontal, 20)
                .padding(.top, 20)
        }
    }

    private func specChip(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(label)
                .font(.obskaMonoCaption(9))
                .tracking(1.2)
                .foregroundStyle(Color.obskaInk2)
            Text(value)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color.obskaInk)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.obskaElevated)
        .overlay(RoundedRectangle(cornerRadius: Obska.radiusChip).stroke(Color.obskaHair, lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: Obska.radiusChip))
    }

    // MARK: - Bid section

    private var bidSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .firstTextBaseline) {
                Text("LANCE ATUAL")
                    .font(.obskaMonoCaption(10))
                    .tracking(1.4)
                    .foregroundStyle(Color.obskaInk2)
                Spacer()
                Text("+18% vs. inicial")
                    .font(.obskaMonoCaption(10))
                    .tracking(1.2)
                    .foregroundStyle(Color.obskaInk2)
            }

            // Large price
            (
                Text(lanceAtual.formatted(.currency(code: "BRL").presentation(.narrow)))
                    .font(.fraunces(54))
                    .foregroundStyle(Color.obskaInk)
            )
            .padding(.top, 6)

            // Bid history
            VStack(spacing: 0) {
                ForEach(Array(historico.reversed().enumerated()), id: \.element.id) { idx, lance in
                    bidRow(lance, isLeader: idx == 0)
                    if idx < historico.count - 1 {
                        Divider().background(Color.obskaHair)
                            .padding(.leading, 42)
                    }
                }
            }
            .padding(.top, 18)
        }
    }

    private func bidRow(_ lance: Lance, isLeader: Bool) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(isLeader ? Color.obskaAccent : Color.obskaElevated)
                    .overlay(Circle().stroke(isLeader ? Color.clear : Color.obskaHair, lineWidth: 1))
                    .frame(width: 30, height: 30)
                Text(String(lance.usuario.prefix(2)).uppercased())
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(isLeader ? Color.white : Color.obskaInk)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(lance.usuario)
                    .font(.system(size: 14, weight: isLeader ? .semibold : .medium))
                    .foregroundStyle(Color.obskaInk)
                Text(lance.dataHora, style: .relative)
                    .font(.obskaMonoCaption(11))
                    .foregroundStyle(Color.obskaInk2)
                    .textCase(.uppercase)
            }

            Spacer()

            Text(lance.valor, format: .currency(code: "BRL"))
                .font(.fraunces(16, weight: .medium))
                .foregroundStyle(isLeader ? Color.obskaAccent : Color.obskaInk)
        }
        .padding(.vertical, 12)
    }

    // MARK: - Sticky CTA card

    private var stickyCTACard: some View {
        VStack(spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("LANCE MÍNIMO")
                        .font(.obskaMonoCaption(9))
                        .tracking(1.4)
                        .foregroundStyle(Color.obskaInk2)
                    Text(lanceMinimo, format: .currency(code: "BRL"))
                        .font(.fraunces(20, weight: .medium))
                        .foregroundStyle(Color.obskaInk)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("ENCERRA")
                        .font(.obskaMonoCaption(9))
                        .tracking(1.4)
                        .foregroundStyle(Color.obskaInk2)
                    Text("02:14:09")
                        .font(.obskaMonoCaption(14))
                        .foregroundStyle(Color.obskaInk)
                }
            }

            Button { showBidSheet = true } label: {
                HStack(spacing: 8) {
                    Text("Dar lance")
                    Image(systemName: "arrow.right")
                        .font(.system(size: 13, weight: .semibold))
                }
                .obskaCTA()
            }
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.obskaHair, lineWidth: 0.5)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 8)
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
                // Current bid header
                VStack(spacing: 4) {
                    Text("LANCE ATUAL")
                        .font(.obskaMonoCaption(10))
                        .tracking(1.4)
                        .foregroundStyle(Color.obskaInk2)
                    Text(lanceAtual, format: .currency(code: "BRL"))
                        .font(.fraunces(36))
                        .foregroundStyle(Color.obskaInk)
                }
                .padding(.top, 8)

                VStack(alignment: .leading, spacing: 8) {
                    Text("LANCE MÍNIMO: \(lanceMinimo.formatted(.currency(code: "BRL")))")
                        .font(.obskaMonoCaption(10))
                        .tracking(1.2)
                        .foregroundStyle(Color.obskaInk2)

                    TextField("R$ 0,00", text: $lanceTexto)
                        .keyboardType(.decimalPad)
                        .font(.fraunces(28))
                        .foregroundStyle(Color.obskaInk)
                        .padding()
                        .background(Color.obskaElevated)
                        .overlay(
                            RoundedRectangle(cornerRadius: Obska.radiusCard)
                                .stroke(Color.obskaHair, lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: Obska.radiusCard))
                        .onChange(of: lanceTexto) { _, _ in erro = nil }

                    if let erro {
                        Text(erro)
                            .font(.system(size: 13))
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
                    HStack(spacing: 8) {
                        Text("Confirmar lance")
                        Image(systemName: "arrow.right")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .obskaCTA(disabled: lanceTexto.isEmpty)
                }
                .disabled(lanceTexto.isEmpty)

                Spacer()
            }
            .padding(.horizontal, 24)
            .background(Color.obskaPaper.ignoresSafeArea())
            .navigationTitle("Dar Lance")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancelar") { dismiss() }
                        .foregroundStyle(Color.obskaInk)
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
                .foregroundStyle(Color(hex: "#2E6B42"))
            Text("Lance registrado!")
                .font(.fraunces(28))
                .foregroundStyle(Color.obskaInk)
            Text("Você está na frente por enquanto.")
                .font(.system(size: 15))
                .foregroundStyle(Color.obskaInk2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial)
    }
}

// MARK: - Color hex helper

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
