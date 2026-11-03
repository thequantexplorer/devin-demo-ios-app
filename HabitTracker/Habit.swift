import Foundation

struct Habit: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var isDone: Bool

    init(id: UUID = UUID(), name: String, isDone: Bool = false) {
        self.id = id
        self.name = name
        self.isDone = isDone
    }
}
