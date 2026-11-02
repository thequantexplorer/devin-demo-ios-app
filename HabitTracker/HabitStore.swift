import Foundation
import Observation

/// Holds the user's habits and saves them as JSON at `fileURL`.
@Observable
final class HabitStore {
    private(set) var habits: [Habit] = []
    let fileURL: URL

    static var defaultFileURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("habits.json")
    }

    init(fileURL: URL = HabitStore.defaultFileURL) {
        self.fileURL = fileURL
        // TODO: load the habits saved at fileURL, if there are any.
    }

    /// Adds a habit. Trims spaces and ignores blank names.
    func add(_ name: String) {
        // TODO: not built yet.
    }

    /// Checks a habit off, or un-checks it if it is already done.
    func toggle(_ habit: Habit) {
        // TODO: not built yet.
    }
}
