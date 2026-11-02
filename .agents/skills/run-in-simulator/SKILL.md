---
name: run-in-simulator
description: Create, build, test and run the HabitTracker iPhone app in the iOS Simulator on a macOS machine.
---

This app needs macOS with Xcode. It does not build on Linux.

## Create the project (only if there is no `HabitTracker.xcodeproj` yet)

SwiftUI, iOS 17, an app target `HabitTracker` (sources in `HabitTracker/`) and a unit test target `HabitTrackerTests` (XCTest, in `HabitTrackerTests/`). Generate the Xcode project with XcodeGen and commit both `project.yml` and `HabitTracker.xcodeproj`:

```sh
brew install xcodegen
xcodegen
```

```yaml
name: HabitTracker
options:
  bundleIdPrefix: com.example
  deploymentTarget:
    iOS: "17.0"
targets:
  HabitTracker:
    type: application
    platform: iOS
    sources: [HabitTracker]
    settings:
      base:
        PRODUCT_BUNDLE_IDENTIFIER: com.example.HabitTracker
        GENERATE_INFOPLIST_FILE: YES
        INFOPLIST_KEY_UILaunchScreen_Generation: YES
        MARKETING_VERSION: "1.0"
        CURRENT_PROJECT_VERSION: "1"
        CODE_SIGNING_ALLOWED: NO
  HabitTrackerTests:
    type: bundle.unit-test
    platform: iOS
    sources: [HabitTrackerTests]
    dependencies:
      - target: HabitTracker
    settings:
      base:
        GENERATE_INFOPLIST_FILE: YES
        CODE_SIGNING_ALLOWED: NO
schemes:
  HabitTracker:
    build:
      targets:
        HabitTracker: all
    test:
      targets: [HabitTrackerTests]
```

Add a `.gitignore` with `build/`, `DerivedData/` and `xcuserdata/`.

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
