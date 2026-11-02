---
name: run-in-simulator
description: Build, test and run the HabitTracker iPhone app in the iOS Simulator on a macOS machine.
---

This app needs macOS with Xcode. It does not build on Linux.

## Pick a simulator

```sh
xcrun simctl list devices available | grep iPhone
```

Copy the ID (the long value in brackets) of one iPhone, for example an iPhone 17:

```sh
SIM=<device-id>
```

## Run the tests

```sh
xcodebuild -project HabitTracker.xcodeproj -scheme HabitTracker \
  -destination "platform=iOS Simulator,id=$SIM" test
```

## Build and open the app

```sh
xcodebuild -project HabitTracker.xcodeproj -scheme HabitTracker \
  -destination "platform=iOS Simulator,id=$SIM" -derivedDataPath build build
xcrun simctl boot "$SIM" || true
open -a Simulator
xcrun simctl install "$SIM" build/Build/Products/Debug-iphonesimulator/HabitTracker.app
xcrun simctl launch "$SIM" com.example.HabitTracker
```

## Check that habits are saved

Quit the app and open it again. The list should look the same.

```sh
xcrun simctl terminate "$SIM" com.example.HabitTracker
xcrun simctl launch "$SIM" com.example.HabitTracker
```

## Record it

Use your screen recording to film the Simulator window while you tap through the app.
If that is not available, `xcrun simctl io "$SIM" recordVideo habits.mp4` records the
simulator screen until you press Ctrl+C.
