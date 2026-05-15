import Foundation
import Observation

@Observable
final class AuthState {
    static let shared = AuthState()

    private(set) var isSignedIn: Bool

    private let userIdKey = "appleUserId"
    private let userNameKey = "appleUserName"

    private init() {
        isSignedIn = UserDefaults.standard.string(forKey: "appleUserId") != nil
    }

    func signIn(userId: String, fullName: String? = nil) {
        UserDefaults.standard.set(userId, forKey: userIdKey)
        if let name = fullName, !name.isEmpty {
            UserDefaults.standard.set(name, forKey: userNameKey)
        }
        isSignedIn = true
    }

    func signOut() {
        UserDefaults.standard.removeObject(forKey: userIdKey)
        UserDefaults.standard.removeObject(forKey: userNameKey)
        isSignedIn = false
    }

    var displayName: String {
        UserDefaults.standard.string(forKey: userNameKey) ?? "Artista"
    }
}
