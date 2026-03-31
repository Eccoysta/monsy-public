import Foundation

struct UserProfile: Identifiable, Codable, Hashable {
    let id: UUID
    var nickname: String
    var avatarURL: String?
    var createdAt: Date
}

enum HabitStatus: String, Codable, Hashable {
    case draft
    case active
    case paused
    case completed
    case dying
}

enum PlantHealthState: String, Codable, Hashable {
    case healthy
    case dying
}

struct HabitChallenge: Identifiable, Codable, Hashable {
    let id: UUID
    var ownerID: UUID
    var title: String
    var goalDays: Int
    var joinCode: String
    var status: HabitStatus
    var memberCount: Int
    var currentStreak: Int
    var currentLevel: Int
    var plantState: PlantHealthState
    var createdAt: Date
}

struct HabitMember: Identifiable, Codable, Hashable {
    var id: String { "\(habitID.uuidString)-\(profileID.uuidString)" }
    let habitID: UUID
    let profileID: UUID
    var role: String
    var joinedAt: Date
}

struct VerificationPhoto: Identifiable, Codable, Hashable {
    let id: UUID
    let habitID: UUID
    let uploadedBy: UUID
    var storagePath: String
    var caption: String?
    var dayIndex: Int
    var createdAt: Date
}

struct PhotoApproval: Codable, Hashable {
    let photoID: UUID
    let profileID: UUID
    var approved: Bool
    var createdAt: Date
}

struct GrowthSnapshot: Identifiable, Codable, Hashable {
    let id: UUID
    let habitID: UUID
    var level: Int
    var healthState: PlantHealthState
    var streakDays: Int
    var goalDays: Int
    var reason: String?
    var createdAt: Date
}

struct HabitDraft: Hashable {
    var title: String = ""
    var goalDays: Int = 32
    var joinCode: String = JoinCodeGenerator.generate()
}

struct PhotoApprovalSummary: Hashable {
    var memberCount: Int
    var approvedCount: Int
    var isFullyApproved: Bool
}
