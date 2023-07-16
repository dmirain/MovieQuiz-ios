import XCTest
@testable import MovieQuiz

struct MockStorageFirstGame: StatisticStorage {
    static var shared: StatisticStorage = Self()

    func get() -> StatisticDto? {
        nil
    }

    func set(_ newValue: StatisticDto) {
        XCTAssertEqual(newValue.averageValue, 100)
        XCTAssertEqual(newValue.gamesCount, 1)
        XCTAssertEqual(newValue.recordRiddlesCount, 10)
        XCTAssertEqual(newValue.recordValue, 10)
    }
}

struct MockStorageSecondGame: StatisticStorage {
    static var shared: StatisticStorage = Self()

    func get() -> StatisticDto? {
        StatisticDto(
            gamesCount: 1,
            recordValue: 5,
            recordRiddlesCount: 10,
            recordDate: Date(),
            averageValue: 50
        )
    }

    func set(_ newValue: StatisticDto) {
        XCTAssertEqual(newValue.averageValue, 45)
        XCTAssertEqual(newValue.gamesCount, 2)
        XCTAssertEqual(newValue.recordRiddlesCount, 10)
        XCTAssertEqual(newValue.recordValue, 5)
    }
}
