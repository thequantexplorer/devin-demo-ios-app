import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "No habits yet",
                systemImage: "checklist",
                description: Text("Habits you add will show up here.")
            )
            .navigationTitle("Habits")
        }
    }
}

#Preview {
    ContentView()
}
