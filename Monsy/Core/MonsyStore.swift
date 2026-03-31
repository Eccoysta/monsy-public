import Foundation
import SwiftUI

@MainActor
final class MonsyStore: ObservableObject {
    @Published var hasCompletedOnboarding = false
    @Published var nickname: String = "\u00D6mer"
    @Published var selectedAvatarName: String = "person.crop.circle"
    @Published var draft = HabitDraft(title: "Water the plant", goalDays: 32)
    @Published var activeHabit = HabitChallenge(
        id: UUID(),
        ownerID: UUID(),
        title: "Water the plant",
        goalDays: 32,
        joinCode: JoinCodeGenerator.generate(),
        status: .active,
        memberCount: 2,
        currentStreak: 7,
        currentLevel: 4,
        plantState: .healthy,
        createdAt: Date()
    )
    @Published var sampleApprovals: [PhotoApproval] = []
    @Published var uploadedPhotoName: String?

    var currentGrowthLevel: Int {
        GrowthEngine.level(
            for: activeHabit.currentStreak,
            goalDays: activeHabit.goalDays,
            plantState: activeHabit.plantState
        )
    }

    var progressFraction: Double {
        GrowthEngine.progressFraction(completedDays: activeHabit.currentStreak, goalDays: activeHabit.goalDays)
    }

    var approvalSummary: PhotoApprovalSummary {
        ApprovalEngine.summary(memberCount: activeHabit.memberCount, approvals: sampleApprovals)
    }

    func finishOnboarding() {
        hasCompletedOnboarding = true
    }

    func createHabit() {
        activeHabit = HabitChallenge(
            id: UUID(),
            ownerID: UUID(),
            title: draft.title.isEmpty ? "New Habit" : draft.title,
            goalDays: max(2, draft.goalDays),
            joinCode: JoinCodeGenerator.generate(),
            status: .draft,
            memberCount: 1,
            currentStreak: 0,
            currentLevel: 1,
            plantState: .healthy,
            createdAt: Date()
        )
    }

    func joinHabit(withCode code: String) {
        activeHabit.joinCode = code.uppercased()
        activeHabit.memberCount = max(activeHabit.memberCount, 2)
        activeHabit.status = .active
    }

    func uploadSamplePhoto() {
        uploadedPhotoName = "sample-habit-photo.jpg"
    }

    func advanceStreak(by days: Int = 1) {
        activeHabit.currentStreak = max(0, activeHabit.currentStreak + days)
        activeHabit.currentLevel = currentGrowthLevel
        activeHabit.plantState = .healthy
    }

    func breakStreak() {
        activeHabit.plantState = .dying
        activeHabit.currentLevel = max(1, activeHabit.currentLevel - 1)
    }
}
