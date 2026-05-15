import SwiftUI
import SwiftData

struct DetalheObraView: View {
    @Bindable var obra: ObraDeArte
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @State private var showEditSheet = false
    @State private var showDeleteAlert = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                // Hero image
                if let imageData = obra.image, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, minHeight: 1)
                }

                // Content
                VStack(alignment: .leading, spacing: 20) {
                    // Title + date
                    VStack(alignment: .leading, spacing: 4) {
                        Text(obra.titulo)
                            .font(.fraunces(28))
                            .tracking(-0.6)
                            .foregroundStyle(Color.obskaInk)

                        Text(obra.dataCriacao.formatted(date: .long, time: .omitted))
                            .font(.obskaMonoCaption(11))
                            .tracking(0.4)
                            .foregroundStyle(Color.obskaInk2)
                    }

                    if !obra.descricao.isEmpty {
                        Text(obra.descricao)
                            .font(.system(size: 15))
                            .lineSpacing(4)
                            .foregroundStyle(Color.obskaInk)
                    }

                    Divider().background(Color.obskaHair)

                    // Info chips
                    VStack(spacing: 0) {
                        if let preco = obra.preco {
                            infoLinha(label: "PREÇO", valor: preco.formatted(.currency(code: "BRL")))
                        }
                        infoLinha(label: "FORMATO", valor: obra.formatoArquivo.uppercased())
                    }
                }
                .padding(20)
                .padding(.bottom, 32)
            }
        }
        .background(Color.obskaPaper)
        .ignoresSafeArea(edges: .top)
        .navigationBarHidden(true)
        .overlay(alignment: .top) {
            navOverlay
        }
        .sheet(isPresented: $showEditSheet) {
            EditObraView(obra: obra)
        }
        .alert("Excluir obra?", isPresented: $showDeleteAlert) {
            Button("Cancelar", role: .cancel) {}
            Button("Excluir", role: .destructive) {
                dismiss()
                context.delete(obra)
            }
        } message: {
            Text("Essa ação não pode ser desfeita.")
        }
    }

    // MARK: - Nav overlay (over hero image)

    private var navOverlay: some View {
        HStack {
            ObskaCircleButton(systemName: "chevron.left", frosted: true) { dismiss() }
            Spacer()
            Menu {
                Button { showEditSheet = true } label: {
                    Label("Editar obra", systemImage: "pencil")
                }
                Button(role: .destructive) {
                    showDeleteAlert = true
                } label: {
                    Label("Excluir obra", systemImage: "trash")
                }
            } label: {
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: Obska.navButtonSize, height: Obska.navButtonSize)
                    Image(systemName: "ellipsis")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color(UIColor.label))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 60)
    }

    // MARK: - Info row

    private func infoLinha(label: String, valor: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Divider().background(Color.obskaHair)
            HStack(alignment: .center) {
                Text(label)
                    .font(.obskaMonoCaption(10))
                    .tracking(1.2)
                    .foregroundStyle(Color.obskaInk2)
                    .frame(width: 72, alignment: .leading)
                Text(valor)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color.obskaInk)
            }
        }
        .padding(.vertical, 8)
    }
}
