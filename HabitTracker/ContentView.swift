import SwiftUI

struct ContentView: View {
    @Bindable var store: HabitStore
    @State private var newHabitName = ""
    @FocusState private var isFieldFocused: Bool

    private var canAdd: Bool {
        !newHabitName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var todayText: String {
        Date.now.formatted(.dateTime.weekday(.wide).month(.wide).day())
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    AddHabitBar(name: $newHabitName, isFocused: $isFieldFocused, canAdd: canAdd, onAdd: addHabit)
                } header: {
                    if #unavailable(iOS 26) {
                        DateSubtitle(text: todayText)
                    }
                }

                if !store.habits.isEmpty {
                    Section {
                        ProgressHeader(done: store.doneCount, total: store.habits.count)
                    }
                    .transition(.opacity)

                    Section {
                        ForEach(store.habits) { habit in
                            HabitRow(habit: habit) {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    store.toggle(habit)
                                }
                            }
                        }
                        .onDelete { offsets in
                            withAnimation(.easeInOut(duration: 0.2)) {
                                store.delete(at: offsets)
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .listSectionSpacing(16)
            .navigationTitle("Today")
            .navigationBarTitleDisplayMode(.large)
            .modifier(NavigationSubtitle(text: todayText))
            .overlay {
                if store.habits.isEmpty {
                    ContentUnavailableView {
                        Label("No habits yet", systemImage: "leaf")
                    } description: {
                        Text("Add one above to get started.")
                    }
                    .padding(.top, 48)
                    .allowsHitTesting(false)
                    .transition(.opacity)
                }
            }
            .sensoryFeedback(.success, trigger: store.doneCount) { old, new in new > old }
            .alert("Something went wrong", isPresented: errorBinding) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(store.errorMessage ?? "")
            }
        }
    }

    private var errorBinding: Binding<Bool> {
        Binding(
            get: { store.errorMessage != nil },
            set: { if !$0 { store.errorMessage = nil } }
        )
    }

    private func addHabit() {
        withAnimation(.easeOut(duration: 0.2)) {
            if store.add(newHabitName) {
                newHabitName = ""
            }
        }
        isFieldFocused = true
    }
}

private struct NavigationSubtitle: ViewModifier {
    let text: String

    func body(content: Content) -> some View {
        if #available(iOS 26, *) {
            content.navigationSubtitle(text)
        } else {
            content
        }
    }
}

private struct DateSubtitle: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.title3)
            .foregroundStyle(Color(.secondaryLabel))
            .textCase(nil)
            .padding(.leading, -4)
            .padding(.bottom, 8)
            .accessibilityAddTraits(.isHeader)
    }
}

private struct AddHabitBar: View {
    @Binding var name: String
    var isFocused: FocusState<Bool>.Binding
    let canAdd: Bool
    let onAdd: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            TextField("New habit", text: $name)
                .focused(isFocused)
                .submitLabel(.done)
                .onSubmit(onAdd)
                .textInputAutocapitalization(.sentences)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color(.tertiarySystemFill))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .strokeBorder(Color.accentColor, lineWidth: isFocused.wrappedValue ? 1.5 : 0)
                )
                .animation(.easeInOut(duration: 0.15), value: isFocused.wrappedValue)

            Button(action: onAdd) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 32))
                    .symbolRenderingMode(.hierarchical)
            }
            .buttonStyle(PressableButtonStyle())
            .disabled(!canAdd)
            .accessibilityLabel("Add habit")
        }
        .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
    }
}

private struct PressableButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(isEnabled ? Color.accentColor : Color(.tertiaryLabel))
            .scaleEffect(configuration.isPressed ? 0.88 : 1)
            .opacity(configuration.isPressed ? 0.7 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
            .animation(.easeInOut(duration: 0.15), value: isEnabled)
    }
}

private struct ProgressHeader: View {
    let done: Int
    let total: Int

    private var progress: Double { total == 0 ? 0 : Double(done) / Double(total) }

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .stroke(Color(.tertiarySystemFill), lineWidth: 6)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                Image(systemName: done == total ? "checkmark" : "flame.fill")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(done == total ? Color.accentColor : Color(.tertiaryLabel))
                    .contentTransition(.symbolEffect(.replace))
            }
            .frame(width: 48, height: 48)
            .animation(.easeInOut(duration: 0.25), value: progress)

            VStack(alignment: .leading, spacing: 2) {
                Text("\(done) of \(total) done")
                    .font(.headline)
                    .contentTransition(.numericText())
                Text(done == total ? "All done for today" : "Keep it going")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .animation(.easeInOut(duration: 0.2), value: done)

            Spacer(minLength: 0)
        }
        .padding(.vertical, 8)
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
                    .foregroundStyle(habit.isDone ? .secondary : .primary)

                Spacer(minLength: 0)
            }
            .padding(.vertical, 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(habit.isDone ? .isSelected : [])
        .accessibilityHint(habit.isDone ? "Double tap to uncheck" : "Double tap to check off")
    }
}

#Preview("Empty") {
    ContentView(store: HabitStore(fileURL: URL.temporaryDirectory.appending(path: "preview-empty.json")))
}
