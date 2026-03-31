import SwiftUI

@main
struct MonsyApp: App {
    @StateObject private var store = MonsyStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
