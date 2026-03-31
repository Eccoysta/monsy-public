import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: MonsyStore

    var body: some View {
        NavigationStack {
            Group {
                if store.hasCompletedOnboarding {
                    HomeView()
                } else {
                    OnboardingView()
                }
            }
        }
    }
}

struct HomeView: View {
    @EnvironmentObject private var store: MonsyStore

    var body: some View {
        List {
            Section("Current challenge") {
                NavigationLink("Open habit detail") {
                    HabitDetailView()
                }

                NavigationLink("Create habit") {
                    CreateHabitView()
                }

                NavigationLink("Join habit") {
                    JoinHabitView()
                }
            }

            Section("Profile") {
                NavigationLink("Apple Sign-In profile setup") {
                    ProfileSetupView()
                }
            }

            Section("Status") {
                LabeledContent("Join code", value: store.activeHabit.joinCode)
                LabeledContent("Growth level", value: "\(store.currentGrowthLevel)/16")
                LabeledContent("Approval", value: store.approvalSummary.isFullyApproved ? "Ready" : "Waiting")
            }
        }
        .navigationTitle("Monsy")
    }
}
