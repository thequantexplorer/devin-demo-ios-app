import Foundation
import Observation

@Observable
final class HabitStore {
    private(set) var habits: [Habit] = []
    var errorMessage: String?

    private let fileURL: URL

    static var defaultFileURL: URL {
        URL.documentsDirectory.appending(path: "habits.json")
    }

    init(fileURL: URL = HabitStore.defaultFileURL) {
        self.fileURL = fileURL
        load()
    }

    var doneCount: Int { habits.filter(\.isDone).count }

    var progress: Double {
        habits.isEmpty ? 0 : Double(doneCount) / Double(habits.count)
    }

    @discardableResult
    func add(_ name: String) -> Bool {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }
        habits.append(Habit(name: trimmed))
        save()
        return true
    }

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
            errorMessage = "Your saved habits couldn't be read."
        }
    }

    private func save() {
        do {
            let data = try JSONEncoder().encode(habits)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            errorMessage = "Your habits couldn't be saved."
        }
    }
}
