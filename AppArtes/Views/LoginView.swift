import SwiftUI

struct LoginView: View {
    @Environment(AuthState.self) private var auth

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 16) {
                    Image(systemName: "photo.artframe")
                        .font(.system(size: 64))
                        .foregroundStyle(.white)

                    Text("AppArtes")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(.white)

                    Text("Sua galeria de arte pessoal")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.6))
                }

                Spacer()

                VStack(spacing: 16) {
                    Button {
                        auth.signIn(userId: "mock-user", fullName: nil)
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "applelogo")
                                .font(.system(size: 18, weight: .medium))
                            Text("Continuar com Apple")
                                .font(.system(size: 17, weight: .medium))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(.white)
                        .foregroundStyle(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }

                    Text("Ao continuar, você concorda com nossos Termos de Uso e Política de Privacidade.")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.4))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 48)
            }
        }
    }
}
