import SwiftUI

struct CreateHabitView: View {
    @EnvironmentObject private var store: MonsyStore

    var body: some View {
        Form {
            Section("Habit details") {
                TextField("Habit title", text: $store.draft.title)
                Stepper("Goal length: \(store.draft.goalDays) days", value: $store.draft.goalDays, in: 2...365)
            }

            Section("Join code") {
                HStack {
                    Text(store.draft.joinCode)
                        .font(.title.monospacedDigit().bold())
                    Spacer()
                    Button("Regenerate") {
                        store.draft.joinCode = JoinCodeGenerator.generate()
                    }
                }
                Text("This code is shared with friends so they can join the challenge.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section {
                Button("Create habit") {
                    store.createHabit()
                }
            }
        }
        .navigationTitle("Create habit")
    }
}
