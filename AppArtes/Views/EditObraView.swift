import SwiftUI
import SwiftData

struct EditObraView: View {
    @Bindable var obra: ObraDeArte
    @Environment(\.dismiss) private var dismiss
    @State private var precoTexto: String

    init(obra: ObraDeArte) {
        self.obra = obra
        _precoTexto = State(initialValue: obra.preco.map { String(format: "%.2f", $0) } ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Título") {
                    TextField("Título da obra", text: $obra.titulo)
                        .autocorrectionDisabled()
                }

                Section("Descrição") {
                    TextField("Descreva a obra...", text: $obra.descricao, axis: .vertical)
                        .lineLimit(3...8)
                        .autocorrectionDisabled()
                }

                Section("Preço") {
                    HStack {
                        Text("R$")
                            .foregroundStyle(.secondary)
                        TextField("0,00", text: $precoTexto)
                            .keyboardType(.decimalPad)
                    }
                }

                Section("Data de criação") {
                    DatePicker(
                        "",
                        selection: $obra.dataCriacao,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.compact)
                    .labelsHidden()
                }
            }
            .navigationTitle("Editar Obra")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Salvar") {
                        obra.preco = Double(precoTexto.replacingOccurrences(of: ",", with: "."))
                        dismiss()
                    }
                    .bold()
                    .disabled(obra.titulo.isEmpty)
                }
            }
        }
    }
}
