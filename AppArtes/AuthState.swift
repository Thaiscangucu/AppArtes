import Foundation
import Observation

@Observable
final class AuthState {
    static let shared = AuthState()

    private(set) var isSignedIn: Bool
    var displayName: String { didSet { UserDefaults.standard.set(displayName, forKey: userNameKey) } }
    var handle: String { didSet { UserDefaults.standard.set(handle, forKey: "profileHandle") } }
    var bio: String { didSet { UserDefaults.standard.set(bio, forKey: "profileBio") } }

    private let userIdKey = "appleUserId"
    private let userNameKey = "appleUserName"

    private init() {
        isSignedIn = UserDefaults.standard.string(forKey: "appleUserId") != nil
        displayName = UserDefaults.standard.string(forKey: "appleUserName") ?? "Artista"
        handle = UserDefaults.standard.string(forKey: "profileHandle") ?? "@artista"
        bio = UserDefaults.standard.string(forKey: "profileBio") ?? ""
    }

    var initials: String {
        let words = displayName.split(separator: " ").prefix(2)
        let result = words.map { String($0.prefix(1)).uppercased() }.joined()
        return result.isEmpty ? "A" : result
    }

    func signIn(userId: String, fullName: String? = nil) {
        UserDefaults.standard.set(userId, forKey: userIdKey)
        if let name = fullName, !name.isEmpty {
            displayName = name
        }
        isSignedIn = true
    }

    func signOut() {
        UserDefaults.standard.removeObject(forKey: userIdKey)
        UserDefaults.standard.removeObject(forKey: userNameKey)
        UserDefaults.standard.removeObject(forKey: "profileHandle")
        UserDefaults.standard.removeObject(forKey: "profileBio")
        isSignedIn = false
    }
}
