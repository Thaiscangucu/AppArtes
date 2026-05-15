import SwiftUI
import SwiftData

struct DetalheObraView: View {
    @Bindable var obra: ObraDeArte
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @State private var showEditSheet = false
    @State private var showDeleteAlert = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                if let imageData = obra.image, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                }

                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(obra.titulo)
                            .font(.title2).bold()
                        Text(obra.dataCriacao.formatted(date: .long, time: .omitted))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    if !obra.descricao.isEmpty {
                        Text(obra.descricao)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }

                    Divider()

                    VStack(spacing: 0) {
                        if let preco = obra.preco {
                            infoLinha(label: "Preço", valor: preco.formatted(.currency(code: "BRL")))
                        }
                        infoLinha(label: "Formato", valor: obra.formatoArquivo)
                    }
                }
                .padding()
                .padding(.bottom, 32)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
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
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .padding(8)
                        .background(Circle().fill(Color(white: 0.95)))
                        .foregroundColor(.black)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        showEditSheet = true
                    } label: {
                        Label("Editar obra", systemImage: "pencil")
                    }
                    Button(role: .destructive) {
                        showDeleteAlert = true
                    } label: {
                        Label("Excluir obra", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .padding(8)
                        .background(Circle().fill(Color(white: 0.95)))
                        .foregroundColor(.black)
                }
            }
        }
    }

    @ViewBuilder
    private func infoLinha(label: String, valor: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Divider()
            HStack {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(width: 64, alignment: .leading)
                Text(valor)
                    .font(.subheadline)
            }
        }
        .padding(.vertical, 8)
    }
}
