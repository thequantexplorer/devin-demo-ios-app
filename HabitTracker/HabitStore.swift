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
        if let data = try? Data(contentsOf: fileURL),
           let saved = try? JSONDecoder().decode([Habit].self, from: data) {
            habits = saved
        }
    }

    /// Adds a habit. Trims spaces and ignores blank names.
    func add(_ name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        habits.append(Habit(name: trimmed))
        save()
    }

    /// Checks a habit off, or un-checks it if it is already done.
    func toggle(_ habit: Habit) {
        guard let index = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        habits[index].isDone.toggle()
        save()
    }

    private func save() {
        do {
            let data = try JSONEncoder().encode(habits)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("HabitStore: failed to save habits: \(error)")
        }
    }
}
