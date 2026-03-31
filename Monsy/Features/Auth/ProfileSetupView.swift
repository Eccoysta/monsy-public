import SwiftUI

struct ProfileSetupView: View {
    @EnvironmentObject private var store: MonsyStore
    @State private var nickname: String = "\u00D6mer"
    @State private var selectedAvatar = "person.crop.circle"

    private let avatarChoices = [
        "person.crop.circle",
        "leaf.circle",
        "camera.circle",
        "sparkles"
    ]

    var body: some View {
        Form {
            Section("Apple Sign-In") {
                Label("Sign in with Apple only", systemImage: "apple.logo")
                Text("This scaffold keeps the auth entry point aligned with the product requirement.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section("Profile") {
                TextField("Nickname", text: $nickname)
                Picker("Avatar", selection: $selectedAvatar) {
                    ForEach(avatarChoices, id: \.self) { avatar in
                        Label(avatar, systemImage: avatar).tag(avatar)
                    }
                }
            }

            Section {
                Button("Save profile") {
                    store.nickname = nickname
                    store.selectedAvatarName = selectedAvatar
                }
            }
        }
        .navigationTitle("Profile")
    }
}
