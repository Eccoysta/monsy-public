import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var store: MonsyStore

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "leaf.fill")
                .font(.system(size: 56))
                .foregroundStyle(.green)

            Text("Grow habits together")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)

            Text("Create a challenge, share a 5-digit join code, upload proof photos, and let the whole group approve each streak before the Monstera levels up.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)

            VStack(alignment: .leading, spacing: 12) {
                TutorialRow(number: "1", title: "Start with Apple Sign-In", detail: "Pick a nickname and an avatar.")
                TutorialRow(number: "2", title: "Create or join a habit", detail: "Join with a 5-digit code and wait for at least 2 users.")
                TutorialRow(number: "3", title: "Verify every streak", detail: "Everyone must approve the photo for the streak to count.")
                TutorialRow(number: "4", title: "Watch the plant grow", detail: "Progress maps to 16 Monstera levels and can recover after a break.")
            }
            .padding()
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 24))
            .padding(.horizontal)

            Button {
                store.finishOnboarding()
            } label: {
                Text("Continue")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.green, in: RoundedRectangle(cornerRadius: 16))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal)
            .padding(.top, 8)

            Spacer()
        }
        .padding(.vertical)
    }
}

private struct TutorialRow: View {
    let number: String
    let title: String
    let detail: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(number)
                .frame(width: 28, height: 28)
                .background(.green.opacity(0.15), in: Circle())
                .foregroundStyle(.green)
                .bold()
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.headline)
                Text(detail).font(.subheadline).foregroundStyle(.secondary)
            }
        }
    }
}
