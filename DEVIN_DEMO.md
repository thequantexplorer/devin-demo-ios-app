# Devin demo: build an iPhone app and run it in the Simulator

**What it shows:** Devin works on a macOS machine with Xcode. It builds a habit tracker in a SwiftUI app, makes the unit tests pass, runs the app in the iOS Simulator, and puts a recording of it in the pull request.

**Needs:** GitHub. A Devin plan with macOS sessions (Pro and Teams have them).

More demos: [devin-advanced-demos](https://github.com/thequantexplorer/devin-advanced-demos)

## Set it up

1. Click **Use this template → Create a new repository**, choose your GitHub account or org as the owner, and keep the name `devin-demo-ios-app`. The links and prompt below assume that name. Use the template rather than a fork: pull requests on a fork go to the original repo by default.
2. In Devin, open [**Settings → Connections → GitHub**](https://app.devin.ai/settings/connections/github) and make sure Devin can access the new repository.
3. Open [app.devin.ai](https://app.devin.ai). In the platform menu below the prompt box, choose **macOS**. This gives the session Xcode and the iOS Simulator. See [macOS support](https://docs.devin.ai/onboard-devin/environment/macos-support).

## The starting problem

The app opens to an empty "No habits yet" screen, and `HabitStore` is not built yet. Running the tests shows 4 of 5 failing:

```text
HabitStoreTests.testAddHabit : XCTAssertEqual failed: ("[]") is not equal to ("["Drink water"]")
HabitStoreTests.testAddTrimsSpacesAndIgnoresBlankNames : XCTAssertEqual failed: ("[]") is not equal to ("["Read"]")
HabitStoreTests.testToggleChecksOffAndBack : XCTUnwrap failed: expected non-nil value of type "Habit"
HabitStoreTests.testHabitsAreStillThereAfterRelaunch : XCTUnwrap failed: expected non-nil value of type "Habit"
```

## Prompt

Paste this into the macOS session. Replace `<you>` with your GitHub user or org.

```text
Build a habit tracker in https://github.com/<you>/devin-demo-ios-app, a small SwiftUI iPhone app. Read the README and the run-in-simulator skill in .agents/skills first.

This needs Xcode, so work on macOS. If this session is not on macOS, start a macOS child session for the work.

1. Run the unit tests in the iOS Simulator and show me the failures.
2. Finish HabitStore so all the tests pass: add a habit (trim spaces, ignore blank names), check a habit off and back, and save the list so it is still there after the app restarts.
3. Replace the empty screen in ContentView with the habit list: a text field and an Add button at the top, one row per habit, and tap a row to check it off (show a checkmark and strike through the name). Keep the empty screen when there are no habits.
4. Run the app in the iOS Simulator and record a short video: add three habits, check off two, quit and reopen the app, and show the list is the same.

Open a PR with the passing test output and the recording in the description, and send me the recording here.
```

## What to watch

- Devin runs the tests first and shows you the failures.
- Open the **Computer** tab to watch the app in the iOS Simulator while Devin taps through it.

## Done when

- All 5 tests pass.
- The PR has a recording of the app in the Simulator: adding habits, checking them off, and the list still there after the app reopens.
