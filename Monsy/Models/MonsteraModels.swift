import Foundation
import SwiftUI

enum MonsteraGrowthStage: Int, CaseIterable, Identifiable {
    case seedling = 0
    case sprout
    case unfurlingLeaf
    case twoLeaves
    case threeLeaves
    case rootStrengthening
    case balanced
    case branching
    case climbing
    case lush
    case thriving
    case blooming
    case canopy
    case seasoned
    case legacy
    case guardian

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .seedling: return "Seedling"
        case .sprout: return "Sprout"
        case .unfurlingLeaf: return "Unfurling Leaf"
        case .twoLeaves: return "Two Leaves"
        case .threeLeaves: return "Three Leaves"
        case .rootStrengthening: return "Root Strengthening"
        case .balanced: return "Balanced"
        case .branching: return "Branching"
        case .climbing: return "Climbing"
        case .lush: return "Lush"
        case .thriving: return "Thriving"
        case .blooming: return "Blooming"
        case .canopy: return "Canopy"
        case .seasoned: return "Seasoned"
        case .legacy: return "Legacy"
        case .guardian: return "Guardian"
        }
    }

    var subtitle: String {
        switch self {
        case .seedling: return "A fresh start with one tiny leaf."
        case .sprout: return "A first sign of momentum."
        case .unfurlingLeaf: return "The plant is opening up."
        case .twoLeaves: return "Two leaves and a habit taking shape."
        case .threeLeaves: return "A stronger pattern is forming."
        case .rootStrengthening: return "Roots are settling in."
        case .balanced: return "Healthy rhythm, steady growth."
        case .branching: return "New branches reflect new streaks."
        case .climbing: return "Reaching higher with the group."
        case .lush: return "Fuller leaves and better consistency."
        case .thriving: return "This Monstera is clearly thriving."
        case .blooming: return "The habit is now part of the routine."
        case .canopy: return "A canopy of momentum across the group."
        case .seasoned: return "A mature streak with strong roots."
        case .legacy: return "A long-running habit worth protecting."
        case .guardian: return "A near-max plant that leads the garden."
        }
    }

    var emoji: String {
        switch self {
        case .seedling: return "🌱"
        case .sprout: return "🪴"
        case .unfurlingLeaf: return "🍃"
        case .twoLeaves: return "🌿"
        case .threeLeaves: return "🌿"
        case .rootStrengthening: return "🪴"
        case .balanced: return "🌿"
        case .branching: return "🍃"
        case .climbing: return "🌿"
        case .lush: return "🪴"
        case .thriving: return "🌿"
        case .blooming: return "🍃"
        case .canopy: return "🌿"
        case .seasoned: return "🪴"
        case .legacy: return "🍃"
        case .guardian: return "🌿"
        }
    }
}

enum MonsteraHealthState: String, CaseIterable, Identifiable {
    case healthy
    case thirsty
    case wilting
    case dying
    case dead

    var id: String { rawValue }

    var label: String {
        rawValue.capitalized
    }
}

struct HabitApproval: Identifiable {
    let id = UUID()
    let name: String
    let approved: Bool
}

struct Habit: Identifiable {
    let id = UUID()
    var title: String
    var groupName: String
    var streak: Int
    var stage: MonsteraGrowthStage
    var health: MonsteraHealthState
    var requiredApprovals: Int
    var approvals: [HabitApproval]
    var lastPhotoDate: Date

    var approvedCount: Int {
        approvals.filter(\.approved).count
    }

    var approvalProgress: Double {
        guard requiredApprovals > 0 else { return 1 }
        return Double(approvedCount) / Double(requiredApprovals)
    }

    var needsMoreApprovals: Bool {
        approvedCount < requiredApprovals
    }

    var statusLine: String {
        needsMoreApprovals ? "Waiting on \(requiredApprovals - approvedCount) approval(s)" : "Streak counted for today"
    }

    static let sample = Habit(
        title: "Water the studio Monstera",
        groupName: "Monsy Garden",
        streak: 12,
        stage: .thriving,
        health: .healthy,
        requiredApprovals: 3,
        approvals: [
            HabitApproval(name: "Ömer", approved: true),
            HabitApproval(name: "Mina", approved: true),
            HabitApproval(name: "Can", approved: false)
        ],
        lastPhotoDate: .now
    )
}
