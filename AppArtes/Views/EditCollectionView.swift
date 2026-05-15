import SwiftUI
import SwiftData

struct EditCollectionView: View {
    @Bindable var colecao: Colecao
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @State private var showDeleteAlert = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Nome") {
                    TextField("Título da coleção", text: $colecao.titulo)
                }

                Section {
                    Button(role: .destructive) {
                        showDeleteAlert = true
                    } label: {
                        Label("Excluir coleção", systemImage: "trash")
                    }
                }
            }
            .navigationTitle("Editar Coleção")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("OK") { dismiss() }
                        .bold()
                }
            }
            .alert("Excluir coleção?", isPresented: $showDeleteAlert) {
                Button("Cancelar", role: .cancel) {}
                Button("Excluir", role: .destructive) {
                    context.delete(colecao)
                    dismiss()
                }
            } message: {
                Text("Todas as obras desta coleção também serão excluídas. Essa ação não pode ser desfeita.")
            }
        }
    }
}
