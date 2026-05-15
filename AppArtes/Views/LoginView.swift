import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @Environment(AuthState.self) private var auth
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            Color.obskaPaper.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                VStack(alignment: .leading, spacing: 0) {
                    ObskaMark(size: 52, color: .obskaInk, accent: .obskaAccent)

                    Text("OBSKA")
                        .font(.fraunces(52))
                        .tracking(-1.5)
                        .foregroundStyle(Color.obskaInk)
                        .padding(.top, 20)

                    Text("Sua galeria de arte pessoal.")
                        .font(.obskaMonoCaption(13))
                        .tracking(0.4)
                        .foregroundStyle(Color.obskaInk2)
                        .padding(.top, 8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 32)

                Spacer()

                VStack(spacing: 14) {
                    SignInWithAppleButton(.continue) { request in
                        request.requestedScopes = [.fullName, .email]
                    } onCompletion: { result in
                        guard case .success(let authorization) = result,
                              let credential = authorization.credential as? ASAuthorizationAppleIDCredential
                        else { return }

                        let name = [credential.fullName?.givenName, credential.fullName?.familyName]
                            .compactMap { $0 }
                            .joined(separator: " ")
                        auth.signIn(userId: credential.user, fullName: name.isEmpty ? nil : name)
                    }
                    .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                    .frame(height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: Obska.radiusButton))

                    Text("Ao continuar, você concorda com nossos Termos de Uso e Política de Privacidade.")
                        .font(.obskaMonoCaption(10))
                        .tracking(0.2)
                        .foregroundStyle(Color.obskaInk2)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 52)
            }
        }
    }
}
