import SwiftUI
import PhotosUI
import AuthenticationServices

struct ContentView: View {
    @StateObject private var appleSignIn = AppleSignInCoordinator()
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var weeklyFocus: String = "Daily photo check-ins"

    private let habit = Habit.sample

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    heroCard
                    monsteraCard
                    photoCard
                    approvalCard
                    backendCard
                    signInCard
                }
                .padding()
            }
            .background(
                LinearGradient(
                    colors: [Color(red: 0.92, green: 0.98, blue: 0.93), Color(red: 0.98, green: 0.99, blue: 0.97)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .navigationTitle("Monsy")
        }
    }

    private var heroCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Habit tracking with friends")
                .font(.headline)
                .foregroundStyle(.secondary)
            Text("Grow Monstera plants with streaks.")
                .font(.largeTitle.bold())
            Text("Each habit becomes a Monstera. A daily photo counts only after every group member approves it.")
                .foregroundStyle(.secondary)
            HStack(spacing: 12) {
                badge(text: "16 growth levels")
                badge(text: "Group approvals")
                badge(text: weeklyFocus)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.white, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 20, y: 8)
    }

    private var monsteraCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(habit.title)
                        .font(.title2.bold())
                    Text(habit.groupName)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(habit.stage.emoji)
                    .font(.system(size: 40))
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("\(habit.stage.title) • \(habit.health.label)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                Text(habit.stage.subtitle)
                    .font(.body)
                ProgressView(value: habit.approvalProgress)
                    .tint(.green)
                Text(habit.statusLine)
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(habit.needsMoreApprovals ? .orange : .green)
            }

            HStack {
                stat(label: "Streak", value: "\(habit.streak)")
                Spacer()
                stat(label: "Approvals", value: "\(habit.approvedCount)/\(habit.requiredApprovals)")
                Spacer()
                stat(label: "Last photo", value: habit.lastPhotoDate.formatted(date: .abbreviated, time: .omitted))
            }
        }
        .padding()
        .background(.white, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 20, y: 8)
    }

    private var photoCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Daily photo upload")
                .font(.headline)
            Text("Upload one plant photo every day to keep your Monstera growing.")
                .foregroundStyle(.secondary)

            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                Label("Choose today’s photo", systemImage: "photo.on.rectangle.angled")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)

            Text(selectedPhoto == nil ? "No photo uploaded yet" : "Selected a photo from the library")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.white, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 20, y: 8)
    }

    private var approvalCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Group approval flow")
                .font(.headline)
            ForEach(habit.approvals) { approval in
                HStack {
                    Circle()
                        .fill(approval.approved ? Color.green : Color.orange)
                        .frame(width: 10, height: 10)
                    Text(approval.name)
                    Spacer()
                    Text(approval.approved ? "Approved" : "Pending")
                        .foregroundStyle(.secondary)
                }
            }
            Text("A streak counts when all required group members approve the same daily photo.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.white, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 20, y: 8)
    }

    private var backendCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Backend ready for Supabase")
                .font(.headline)
            Text(SupabaseBootstrap.summary)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.white, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 20, y: 8)
    }

    private var signInCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Apple Sign In")
                .font(.headline)
            Text(appleSignIn.statusMessage)
                .foregroundStyle(.secondary)
            SignInWithAppleButton(.signIn, onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            }, onCompletion: { result in
                appleSignIn.handle(result)
            })
            .signInWithAppleButtonStyle(.black)
            .frame(height: 48)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.white, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 20, y: 8)
    }

    private func badge(text: String) -> some View {
        Text(text)
            .font(.footnote.weight(.semibold))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.green.opacity(0.12), in: Capsule())
            .foregroundStyle(.green)
    }

    private func stat(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label.uppercased())
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.headline)
        }
    }
}

#Preview {
    ContentView()
}
