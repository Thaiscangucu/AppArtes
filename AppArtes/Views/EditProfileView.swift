import SwiftUI

struct EditProfileView: View {
    @Environment(AuthState.self) private var auth
    @Environment(\.dismiss) private var dismiss

    @State private var nome: String = ""
    @State private var handle: String = ""
    @State private var bio: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Nome") {
                    TextField("Seu nome", text: $nome)
                        .autocorrectionDisabled()
                }

                Section("Handle") {
                    TextField("@handle", text: $handle)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }

                Section("Bio") {
                    TextField("Conte um pouco sobre você e sua arte...", text: $bio, axis: .vertical)
                        .lineLimit(3...6)
                        .autocorrectionDisabled()
                }
            }
            .navigationTitle("Editar Perfil")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                nome = auth.displayName
                handle = auth.handle
                bio = auth.bio
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Salvar") {
                        auth.displayName = nome.isEmpty ? auth.displayName : nome
                        auth.handle = handle.isEmpty ? auth.handle : handle
                        auth.bio = bio
                        dismiss()
                    }
                    .bold()
                    .disabled(nome.isEmpty)
                }
            }
        }
    }
}
