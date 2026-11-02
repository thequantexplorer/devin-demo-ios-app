import SwiftUI

struct ContentView: View {
    @Bindable var store: HabitStore
    @State private var newHabitName = ""
    @FocusState private var isFieldFocused: Bool

    private var canAdd: Bool {
        !newHabitName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    addBar
                }

                if !store.habits.isEmpty {
                    Section {
                        ProgressHeader(done: store.doneCount, total: store.habits.count)
                    }

                    Section {
                        ForEach(store.habits) { habit in
                            HabitRow(habit: habit) {
                                withAnimation(.easeOut(duration: 0.2)) {
                                    store.toggle(habit)
                                }
                            }
                        }
                        .onDelete { offsets in
                            withAnimation(.easeOut(duration: 0.2)) {
                                store.delete(at: offsets)
                            }
                        }
                    } header: {
                        Text("Habits")
                    }
                }

                if let errorMessage = store.errorMessage {
                    Section {
                        Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                            .font(.subheadline)
                            .foregroundStyle(.red)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .listSectionSpacing(16)
            .overlay {
                if store.habits.isEmpty {
                    ContentUnavailableView(
                        "No habits yet",
                        systemImage: "checklist",
                        description: Text("Add one above to get started.")
                    )
                    .transition(.opacity)
                }
            }
            .navigationTitle("Today")
            .todaySubtitle(Date.now.formatted(.dateTime.weekday(.wide).month(.wide).day()))
            .sensoryFeedback(.success, trigger: store.doneCount) { old, new in new > old }
        }
    }

    private var addBar: some View {
        HStack(spacing: 12) {
            TextField("New habit", text: $newHabitName)
                .focused($isFieldFocused)
                .submitLabel(.done)
                .onSubmit(addHabit)
                .padding(.horizontal, 16)
                .frame(height: 44)
                .background(Color(.tertiarySystemFill), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .strokeBorder(Color.accentColor, lineWidth: isFieldFocused ? 1.5 : 0)
                }
                .animation(.easeOut(duration: 0.15), value: isFieldFocused)

            Button(action: addHabit) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 36))
                    .symbolRenderingMode(.hierarchical)
            }
            .buttonStyle(PressableButtonStyle())
            .disabled(!canAdd)
            .accessibilityLabel("Add habit")
        }
        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 8))
    }

    private func addHabit() {
        guard canAdd else { return }
        withAnimation(.easeOut(duration: 0.2)) {
            store.add(newHabitName)
        }
        newHabitName = ""
    }
}

private struct ProgressHeader: View {
    let done: Int
    let total: Int

    private var progress: Double {
        total == 0 ? 0 : Double(done) / Double(total)
    }

    private var message: String {
        switch done {
        case 0: "Tap a habit to check it off."
        case total: "Everything's done. Nice work!"
        default: "Keep it going."
        }
    }

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .stroke(Color(.systemFill), lineWidth: 8)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                if done == total {
                    Image(systemName: "checkmark")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(Color.accentColor)
                        .transition(.scale.combined(with: .opacity))
                } else {
                    Text(progress, format: .percent.precision(.fractionLength(0)))
                        .font(.caption.weight(.semibold))
                        .monospacedDigit()
                        .contentTransition(.numericText(value: progress))
                }
            }
            .frame(width: 56, height: 56)

            VStack(alignment: .leading, spacing: 4) {
                Text("\(done) of \(total) done")
                    .font(.title3.weight(.semibold))
                    .contentTransition(.numericText(value: Double(done)))
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
        }
        .padding(.vertical, 8)
        .animation(.easeOut(duration: 0.25), value: progress)
        .accessibilityElement(children: .combine)
    }
}

private struct HabitRow: View {
    let habit: Habit
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 16) {
                Image(systemName: habit.isDone ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 26))
                    .foregroundStyle(habit.isDone ? Color.accentColor : Color(.tertiaryLabel))
                    .symbolEffect(.bounce, value: habit.isDone)
                    .contentTransition(.symbolEffect(.replace))
                Text(habit.name)
                    .font(.body)
                    .strikethrough(habit.isDone)
                    .foregroundStyle(habit.isDone ? Color.secondary : Color.primary)
                Spacer(minLength: 0)
            }
            .frame(minHeight: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(PressableButtonStyle(scale: 0.98))
        .accessibilityAddTraits(habit.isDone ? .isSelected : [])
    }
}

private struct PressableButtonStyle: ButtonStyle {
    var scale: CGFloat = 0.9
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(isEnabled ? Color.accentColor : Color(.tertiaryLabel))
            .scaleEffect(configuration.isPressed ? scale : 1)
            .opacity(configuration.isPressed ? 0.7 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

private extension View {
    @ViewBuilder
    func todaySubtitle(_ subtitle: String) -> some View {
        if #available(iOS 26.0, *) {
            navigationSubtitle(subtitle)
        } else {
            safeAreaInset(edge: .top, spacing: 0) {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 8)
            }
        }
    }
}

#Preview("Habits") {
    let store = HabitStore(fileURL: FileManager.default.temporaryDirectory.appendingPathComponent("preview-habits.json"))
    return ContentView(store: store)
}
