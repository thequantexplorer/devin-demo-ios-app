---
name: design
description: Visual design for the HabitTracker iPhone app. Read before building or changing the UI.
---

## Direction: native iOS, done carefully

It should look like an app Apple could ship: system components, SF Symbols, clear hierarchy, and small delightful details.

- Accent color: a fresh green, `#30B36B` (set it as the app's accent color). Everything else uses system colors so light and dark mode both work.
- Navigation title "Today" in the large style, with today's date (for example "Tuesday, October 27") as a subtitle line under it in secondary text.
- A progress header above the list: a circular ring showing how many habits are done today, with "2 of 3 done" next to it. The ring animates when it changes. Hide it when there are no habits.
- Add bar at the top: a rounded text field ("New habit") and an Add button with a `plus.circle.fill` symbol. The button is disabled when the field is blank. Return on the keyboard also adds.
- List in the `.insetGrouped` style. Each row: a large circle symbol on the left that becomes `checkmark.circle.fill` in the accent color, then the habit name. Checked habits get a strikethrough and secondary color. Use `.symbolEffect(.bounce)` on the check and `.sensoryFeedback(.success, ...)` when a habit is checked.
- Swipe a row to delete.
- Keep the empty state with `ContentUnavailableView`, but make it friendly: "No habits yet" with a short line like "Add one above to get started."
- Animate inserts and check changes with `withAnimation`.

States to screenshot: the empty state, three habits with two checked, and the same in dark mode.

## Rules for every screen

- One clear visual direction, used everywhere. No default framework or browser look (no unstyled inputs, no default blue links, no stock Material purple).
- Sans-serif type only. Use a real type scale with a few sizes, not many. Large, confident headings; quiet secondary text.
- Mostly neutral colors plus one accent. Use color for meaning (selected, done, error), not decoration. No purple or pink.
- Even spacing on an 8 px grid. Generous margins. Line up edges.
- Every interactive element has hover (or pressed), focus and disabled states.
- Design the empty state, the error state and the full state, not just one.
- Small, quick motion (150 to 250 ms) when things appear, change or finish.
- Support light and dark appearance if the platform has it, and check both.

## Check before you open the pull request

1. Take screenshots of every screen and state in the list above.
2. Look at each one at full size. Fix anything that is misaligned, cramped, clipped, low contrast or looks unfinished.
3. Put the final screenshots in the pull request description.
