import SwiftUI
import SwiftData

@main
struct JobTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: JobApplication.self)
    }
}
