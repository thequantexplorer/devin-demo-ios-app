import XCTest
@testable import HabitTracker

final class HabitStoreTests: XCTestCase {
    private var fileURL: URL!

    override func setUp() {
        super.setUp()
        fileURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("habits-\(UUID().uuidString).json")
    }

    override func tearDown() {
        try? FileManager.default.removeItem(at: fileURL)
        super.tearDown()
    }

    func testNewStoreIsEmpty() {
        XCTAssertEqual(HabitStore(fileURL: fileURL).habits, [])
    }

    func testAddHabit() {
        let store = HabitStore(fileURL: fileURL)
        store.add("Drink water")
        XCTAssertEqual(store.habits.map(\.name), ["Drink water"])
        XCTAssertEqual(store.habits.first?.isDone, false)
    }

    func testAddTrimsSpacesAndIgnoresBlankNames() {
        let store = HabitStore(fileURL: fileURL)
        store.add("  Read  ")
        store.add("   ")
        XCTAssertEqual(store.habits.map(\.name), ["Read"])
    }

    func testToggleChecksOffAndBack() throws {
        let store = HabitStore(fileURL: fileURL)
        store.add("Walk")
        let habit = try XCTUnwrap(store.habits.first)
        store.toggle(habit)
        XCTAssertEqual(store.habits.first?.isDone, true)
        store.toggle(habit)
        XCTAssertEqual(store.habits.first?.isDone, false)
    }

    func testHabitsAreStillThereAfterRelaunch() throws {
        let store = HabitStore(fileURL: fileURL)
        store.add("Stretch")
        store.toggle(try XCTUnwrap(store.habits.first))

        let relaunched = HabitStore(fileURL: fileURL)
        XCTAssertEqual(relaunched.habits.map(\.name), ["Stretch"])
        XCTAssertEqual(relaunched.habits.first?.isDone, true)
    }
}
