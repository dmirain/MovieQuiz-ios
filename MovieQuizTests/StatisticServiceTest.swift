import XCTest
@testable import MovieQuiz

struct MockStorageReturnNil: StatisticStorage {
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

struct MockStorageReturnOneGame: StatisticStorage {
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

final class StatisticServiceTest: XCTestCase {

    func testFirstGame() throws {
        let service = StatisticServiceImpl(storage: MockStorageReturnNil())

        let result = service.calculateAndSave(with: GameResultDto(correctAnswers: 10, riddlesCount: 10))

        XCTAssertEqual(result.averageValue, 100)
        XCTAssertEqual(result.gamesCount, 1)
        XCTAssertEqual(result.recordRiddlesCount, 10)
        XCTAssertEqual(result.recordValue, 10)
    }

    func testSecondGame() throws {
        let service = StatisticServiceImpl(storage: MockStorageReturnOneGame())

        let result = service.calculateAndSave(with: GameResultDto(correctAnswers: 4, riddlesCount: 10))

        XCTAssertEqual(result.averageValue, 45)
        XCTAssertEqual(result.gamesCount, 2)
        XCTAssertEqual(result.recordRiddlesCount, 10)
        XCTAssertEqual(result.recordValue, 5)
    }
}
