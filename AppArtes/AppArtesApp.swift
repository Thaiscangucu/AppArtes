import SwiftUI
import SwiftData
import CoreText

@main
struct AppArtesApp: App {
    private var auth = AuthState.shared

    init() {
        registerFonts()
    }

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

    private func registerFonts() {
        for name in ["Fraunces", "Fraunces-Italic"] {
            guard let url = Bundle.main.url(forResource: name, withExtension: "ttf") else { continue }
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }
}
