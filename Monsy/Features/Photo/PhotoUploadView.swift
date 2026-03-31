import SwiftUI

struct PhotoUploadView: View {
    @EnvironmentObject private var store: MonsyStore

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "camera.viewfinder")
                .font(.system(size: 52))
                .foregroundStyle(.green)

            Text("Verification photo")
                .font(.title.bold())

            Text("This placeholder screen will later connect to Supabase storage and the approval workflow.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)

            Button("Upload sample photo") {
                store.uploadSamplePhoto()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle("Photo upload")
    }
}
