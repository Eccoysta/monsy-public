import SwiftUI

struct JoinHabitView: View {
    @EnvironmentObject private var store: MonsyStore
    @State private var joinCode: String = ""

    var body: some View {
        Form {
            Section("Enter code") {
                TextField("12345", text: $joinCode)
                    .keyboardType(.numberPad)
                    .textInputAutocapitalization(.characters)
            }

            Section {
                Button("Join challenge") {
                    store.joinHabit(withCode: joinCode)
                }
                .disabled(joinCode.count < 5)
            }

            Section("Rules") {
                Text("A challenge is designed to start with at least 2 users, then photo approvals must reach consensus before the streak counts.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Join habit")
    }
}
