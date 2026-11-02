import Foundation
import Observation

/// Holds the user's habits and saves them as JSON at `fileURL`.
@Observable
final class HabitStore {
    private(set) var habits: [Habit] = []
    /// Set when the habits could not be loaded or saved.
    private(set) var errorMessage: String?
    let fileURL: URL

    static var defaultFileURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("habits.json")
    }

    init(fileURL: URL = HabitStore.defaultFileURL) {
        self.fileURL = fileURL
        load()
    }

    var doneCount: Int {
        habits.filter(\.isDone).count
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

    func delete(at offsets: IndexSet) {
        habits.remove(atOffsets: offsets)
        save()
    }

    private func load() {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return }
        do {
            let data = try Data(contentsOf: fileURL)
            habits = try JSONDecoder().decode([Habit].self, from: data)
        } catch {
            errorMessage = "Your saved habits couldn't be loaded."
        }
    }

    private func save() {
        do {
            let data = try JSONEncoder().encode(habits)
            try data.write(to: fileURL, options: .atomic)
            errorMessage = nil
        } catch {
            errorMessage = "Your changes couldn't be saved."
        }
    }
}
