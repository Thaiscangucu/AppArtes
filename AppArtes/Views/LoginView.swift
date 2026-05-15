import SwiftUI

struct LoginView: View {
    @Environment(AuthState.self) private var auth

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
                    Button {
                        auth.signIn(userId: "mock-user", fullName: nil)
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "applelogo")
                                .font(.system(size: 16, weight: .medium))
                            Text("Continuar com Apple")
                        }
                        .obskaCTA()
                    }

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
