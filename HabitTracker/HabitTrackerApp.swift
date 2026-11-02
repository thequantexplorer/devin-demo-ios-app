import SwiftUI

@main
struct HabitTrackerApp: App {
    @State private var store = HabitStore()

    var body: some Scene {
        WindowGroup {
            ContentView(store: store)
        }
    }
}
