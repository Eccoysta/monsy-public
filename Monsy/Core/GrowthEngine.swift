import Foundation

struct GrowthEngine {
    static let maxLevels = 16

    static func daysPerLevel(goalDays: Int) -> Double {
        max(1, Double(goalDays) / Double(maxLevels))
    }

    static func level(for completedDays: Int, goalDays: Int, plantState: PlantHealthState = .healthy) -> Int {
        let denominator = daysPerLevel(goalDays: goalDays)
        let progress = Double(max(0, completedDays)) / denominator
        let baseLevel = min(maxLevels, max(1, Int(floor(progress)) + 1))

        switch plantState {
        case .healthy:
            return baseLevel
        case .dying:
            return max(1, baseLevel - 1)
        }
    }

    static func plantState(streakBroken: Bool) -> PlantHealthState {
        streakBroken ? .dying : .healthy
    }

    static func progressFraction(completedDays: Int, goalDays: Int) -> Double {
        let goal = max(1, Double(goalDays))
        return min(1, max(0, Double(completedDays) / goal))
    }
}
