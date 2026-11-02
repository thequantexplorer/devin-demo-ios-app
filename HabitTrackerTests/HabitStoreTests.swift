import XCTest
@testable import HabitTracker

final class HabitStoreTests: XCTestCase {
    private var fileURL: URL!

    override func setUp() {
        super.setUp()
        fileURL = FileManager.default.temporaryDirectory
            .appending(path: "habits-\(UUID().uuidString).json")
    }

    override func tearDown() {
        try? FileManager.default.removeItem(at: fileURL)
        super.tearDown()
    }

    func testNewStoreIsEmpty() {
        let store = HabitStore(fileURL: fileURL)
        XCTAssertTrue(store.habits.isEmpty)
        XCTAssertEqual(store.doneCount, 0)
    }

    func testAddHabit() {
        let store = HabitStore(fileURL: fileURL)
        XCTAssertTrue(store.add("Drink water"))
        XCTAssertEqual(store.habits.map(\.name), ["Drink water"])
        XCTAssertFalse(store.habits[0].isDone)
    }

    func testAddTrimsWhitespaceAndIgnoresBlankNames() {
        let store = HabitStore(fileURL: fileURL)
        XCTAssertTrue(store.add("   Read 10 pages  \n"))
        XCTAssertFalse(store.add(""))
        XCTAssertFalse(store.add("    "))
        XCTAssertFalse(store.add(" \n\t "))
        XCTAssertEqual(store.habits.map(\.name), ["Read 10 pages"])
    }

    func testCheckHabitOffAndBack() {
        let store = HabitStore(fileURL: fileURL)
        store.add("Stretch")

        store.toggle(store.habits[0])
        XCTAssertTrue(store.habits[0].isDone)
        XCTAssertEqual(store.doneCount, 1)

        store.toggle(store.habits[0])
        XCTAssertFalse(store.habits[0].isDone)
        XCTAssertEqual(store.doneCount, 0)
    }

    func testListPersistsAfterRelaunch() {
        let store = HabitStore(fileURL: fileURL)
        store.add("Drink water")
        store.add("Read")
        store.add("Walk")
        store.toggle(store.habits[0])
        store.toggle(store.habits[2])

        let relaunched = HabitStore(fileURL: fileURL)
        XCTAssertEqual(relaunched.habits, store.habits)
        XCTAssertEqual(relaunched.habits.map(\.name), ["Drink water", "Read", "Walk"])
        XCTAssertEqual(relaunched.habits.map(\.isDone), [true, false, true])
    }
}
