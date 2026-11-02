import SwiftUI

struct ContentView: View {
    @State private var store: HabitStore
    @State private var newHabitName = ""

    init(store: HabitStore = HabitStore()) {
        _store = State(initialValue: store)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    TextField("New habit", text: $newHabitName)
                        .textFieldStyle(.roundedBorder)
                        .submitLabel(.done)
                        .onSubmit(addHabit)
                    Button("Add", action: addHabit)
                        .buttonStyle(.borderedProminent)
                        .disabled(newHabitName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding()

                if store.habits.isEmpty {
                    ContentUnavailableView(
                        "No habits yet",
                        systemImage: "checklist",
                        description: Text("Habits you add will show up here.")
                    )
                } else {
                    List(store.habits) { habit in
                        Button {
                            store.toggle(habit)
                        } label: {
                            HStack {
                                Image(systemName: habit.isDone ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(habit.isDone ? Color.green : Color.secondary)
                                Text(habit.name)
                                    .strikethrough(habit.isDone)
                                    .foregroundStyle(habit.isDone ? Color.secondary : Color.primary)
                                Spacer()
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Habits")
        }
    }

    private func addHabit() {
        store.add(newHabitName)
        newHabitName = ""
    }
}

#Preview {
    ContentView(store: HabitStore(fileURL: FileManager.default.temporaryDirectory
        .appendingPathComponent("preview-habits.json")))
}
