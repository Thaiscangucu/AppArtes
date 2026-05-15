import SwiftUI

struct SettingsView: View {
    @Environment(AuthState.self) private var auth
    @State private var notificacoesAtivas = true
    @State private var modoEscuro = false
    @State private var showSignOutAlert = false

    var body: some View {
        Form {
            Section("Conta") {
                LabeledContent("Nome", value: auth.displayName)
                NavigationLink("Alterar senha") {
                    AlterarSenhaView()
                }
            }

            Section("Preferências") {
                Toggle("Notificações de lances", isOn: $notificacoesAtivas)
                Toggle("Modo escuro", isOn: $modoEscuro)
            }

            Section("Sobre") {
                LabeledContent("Versão", value: "1.0.0")
                NavigationLink("Termos de uso") {
                    TextoLegalView(titulo: "Termos de Uso", texto: Lorem.termosDeUso)
                }
                NavigationLink("Política de privacidade") {
                    TextoLegalView(titulo: "Política de Privacidade", texto: Lorem.politicaPrivacidade)
                }
            }

            Section {
                Button(role: .destructive) {
                    showSignOutAlert = true
                } label: {
                    HStack {
                        Spacer()
                        Text("Sair da conta")
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("Configurações")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Sair da conta?", isPresented: $showSignOutAlert) {
            Button("Cancelar", role: .cancel) {}
            Button("Sair", role: .destructive) { auth.signOut() }
        } message: {
            Text("Você precisará fazer login novamente.")
        }
    }
}

private struct AlterarSenhaView: View {
    @State private var senhaAtual = ""
    @State private var novaSenha = ""
    @State private var confirmarSenha = ""

    var body: some View {
        Form {
            Section("Senha atual") {
                SecureField("Digite sua senha atual", text: $senhaAtual)
            }
            Section("Nova senha") {
                SecureField("Nova senha", text: $novaSenha)
                SecureField("Confirmar nova senha", text: $confirmarSenha)
            }
            Section {
                Button("Salvar") {}
                    .frame(maxWidth: .infinity)
                    .disabled(novaSenha.isEmpty || novaSenha != confirmarSenha)
            }
        }
        .navigationTitle("Alterar Senha")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct TextoLegalView: View {
    let titulo: String
    let texto: String

    var body: some View {
        ScrollView {
            Text(texto)
                .font(.body)
                .foregroundStyle(.secondary)
                .padding()
        }
        .navigationTitle(titulo)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private enum Lorem {
    static let termosDeUso = """
    Ao utilizar o AppArtes, você concorda com estes termos. O aplicativo é destinado ao cadastro, organização e negociação de obras de arte entre usuários.

    Responsabilidades do usuário: você é responsável pela veracidade das informações cadastradas, incluindo descrições, preços e imagens das obras. É proibido cadastrar obras sem os devidos direitos de autoria ou comercialização.

    Lances e transações: os lances realizados no marketplace são vinculantes. Ao confirmar um lance vencedor, o usuário se compromete a realizar o pagamento conforme acordado com o vendedor.

    O AppArtes não se responsabiliza por disputas entre compradores e vendedores, sendo apenas a plataforma intermediária.
    """

    static let politicaPrivacidade = """
    O AppArtes coleta apenas as informações necessárias para o funcionamento do aplicativo: nome e imagens de obras cadastradas pelo usuário. Nenhuma senha é armazenada, pois utilizamos exclusivamente Sign in with Apple.

    Seus dados não são compartilhados com terceiros sem seu consentimento, exceto quando exigido por lei.

    As imagens cadastradas ficam armazenadas localmente no dispositivo e, quando publicadas, em servidores seguros com criptografia em repouso.

    Você pode solicitar a exclusão dos seus dados a qualquer momento pelo e-mail contato@appartes.com.
    """
}
