import XCTest
@testable import Warmupcard

@MainActor
final class WarmupcardTests: XCTestCase {
    func makeStore() -> Store {
        let store = Store()
        store.entries = []
        store.save()
        return store
    }

    func testSeedDataBelowLimit() {
        XCTAssertLessThan(Store.seedData().count, Store.freeTierLimit)
    }

    func testAddIncreasesCount() {
        let store = makeStore()
        let before = store.entries.count
        _ = store.add(WarmupLog())
        XCTAssertEqual(store.entries.count, before + 1)
    }

    func testCanAddMoreWhenUnderLimit() {
        let store = makeStore()
        XCTAssertTrue(store.canAddMore)
    }

    func testFreeTierLimitBlocksAdd() {
        let store = makeStore()
        for _ in 0..<Store.freeTierLimit {
            _ = store.add(WarmupLog())
        }
        XCTAssertFalse(store.canAddMore)
        let result = store.add(WarmupLog())
        XCTAssertFalse(result)
        XCTAssertEqual(store.entries.count, Store.freeTierLimit)
    }

    func testProBypassesLimit() {
        let store = makeStore()
        store.isPro = true
        for _ in 0..<(Store.freeTierLimit + 5) {
            _ = store.add(WarmupLog())
        }
        XCTAssertEqual(store.entries.count, Store.freeTierLimit + 5)
    }

    func testDeleteRemovesEntry() {
        let store = makeStore()
        _ = store.add(WarmupLog())
        XCTAssertEqual(store.entries.count, 1)
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.entries.count, 0)
    }

    func testUpdateModifiesEntry() {
        let store = makeStore()
        _ = store.add(WarmupLog())
        var entry = store.entries[0]
        entry.notes = "updated"
        store.update(entry)
        XCTAssertEqual(store.entries[0].notes, "updated")
    }

    func testPersistenceRoundTrip() {
        let store = makeStore()
        _ = store.add(WarmupLog(notes: "persisted"))
        let reloaded = Store()
        XCTAssertTrue(reloaded.entries.contains(where: { $0.notes == "persisted" }))
    }
}
