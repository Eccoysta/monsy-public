import SwiftUI

struct HabitDetailView: View {
    @EnvironmentObject private var store: MonsyStore

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Image(systemName: store.activeHabit.plantState == .healthy ? "leaf.fill" : "exclamationmark.triangle.fill")
                        .font(.system(size: 54))
                        .foregroundStyle(store.activeHabit.plantState == .healthy ? .green : .orange)
                    Text(store.activeHabit.title)
                        .font(.title.bold())
                    Text("Join code: \(store.activeHabit.joinCode)")
                        .font(.headline.monospacedDigit())
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 24))

                HStack(spacing: 12) {
                    MetricCard(title: "Streak", value: "\(store.activeHabit.currentStreak) days")
                    MetricCard(title: "Growth", value: "\(store.currentGrowthLevel)/16")
                }

                MetricCard(title: "Progress", value: String(format: "%.0f%%", store.progressFraction * 100))

                VStack(alignment: .leading, spacing: 12) {
                    Text("Approval status").font(.headline)
                    Text(store.approvalSummary.isFullyApproved ? "All members approved the latest photo." : "Waiting on \(store.approvalSummary.memberCount - store.approvalSummary.approvedCount) approval(s).")
                        .foregroundStyle(.secondary)
                    NavigationLink("Upload a verification photo") {
                        PhotoUploadView()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 24))
            }
            .padding()
        }
        .navigationTitle("Habit detail")
    }
}

private struct MetricCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.caption).foregroundStyle(.secondary)
            Text(value).font(.title3.bold())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 20))
    }
}
