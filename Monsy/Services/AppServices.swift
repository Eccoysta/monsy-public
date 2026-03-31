import Foundation
import Combine
import AuthenticationServices

struct SupabaseBootstrap {
    static var isConfigured: Bool {
        let urlString = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String
        let anonKey = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String
        return !(urlString ?? "").isEmpty && !(anonKey ?? "").isEmpty
    }

    static var summary: String {
        if isConfigured {
            return "Supabase configuration is present and ready for auth, storage, and habit syncing."
        }
        return "Add SUPABASE_URL and SUPABASE_ANON_KEY to connect Monsy to Supabase."
    }
}

final class AppleSignInCoordinator: ObservableObject {
    @Published var signedInUser: String?
    @Published var statusMessage: String = "Sign in with Apple to sync your streaks."

    func handle(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
                signedInUser = credential.email ?? credential.user
                let displayName = [credential.fullName?.givenName, credential.fullName?.familyName]
                    .compactMap { $0 }
                    .joined(separator: " ")
                statusMessage = displayName.isEmpty
                    ? "Signed in with Apple."
                    : "Signed in as \(displayName)."
            } else {
                statusMessage = "Apple Sign In completed."
            }
        case .failure(let error):
            statusMessage = "Apple Sign In failed: \(error.localizedDescription)"
        }
    }
}
