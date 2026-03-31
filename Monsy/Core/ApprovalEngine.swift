import Foundation

struct ApprovalEngine {
    static func summary(memberCount: Int, approvals: [PhotoApproval]) -> PhotoApprovalSummary {
        let approvedCount = approvals.filter { $0.approved }.count
        let hasMinimumParticipants = memberCount >= 2
        let isFullyApproved = hasMinimumParticipants && approvedCount == memberCount

        return PhotoApprovalSummary(
            memberCount: memberCount,
            approvedCount: approvedCount,
            isFullyApproved: isFullyApproved
        )
    }
}
