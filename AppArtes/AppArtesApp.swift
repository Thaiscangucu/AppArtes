import SwiftUI
import SwiftData

@main
struct AppArtesApp: App {
    private var auth = AuthState.shared

    var body: some Scene {
        WindowGroup {
            if auth.isSignedIn {
                ContentView()
                    .environment(auth)
            } else {
                LoginView()
                    .environment(auth)
            }
        }
        .modelContainer(for: [Colecao.self, ObraDeArte.self])
    }
}
