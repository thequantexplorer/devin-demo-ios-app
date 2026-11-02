# HabitTracker

A small SwiftUI app for iPhone. You list the habits you want to keep and check them off each day.

Right now the app only shows an empty screen. `HabitStore` is not built yet, so 4 of its 5 unit tests fail.

## Layout

| Path | What it is |
| - | - |
| `HabitTracker.xcodeproj` | The Xcode project. Scheme: `HabitTracker`. |
| `HabitTracker/HabitTrackerApp.swift` | App entry point. |
| `HabitTracker/ContentView.swift` | The main screen. |
| `HabitTracker/Habit.swift` | The `Habit` model. |
| `HabitTracker/HabitStore.swift` | Holds the habits and saves them to a JSON file. |
| `HabitTrackerTests/HabitStoreTests.swift` | Unit tests for `HabitStore`. |
| `.agents/skills/run-in-simulator/SKILL.md` | How to build, test and run the app in the iOS Simulator. |

## Requirements

macOS with Xcode 15 or later. The app targets iOS 17.

## Build and test

```sh
xcrun simctl list devices available | grep iPhone   # pick a device ID
xcodebuild -project HabitTracker.xcodeproj -scheme HabitTracker \
  -destination "platform=iOS Simulator,id=<device-id>" test
```

---

This repo is a starter for a Devin demo. See [DEVIN_DEMO.md](DEVIN_DEMO.md) for setup and the prompt.
