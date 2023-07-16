import XCTest
@testable import MovieQuiz

final class StatisticServiceTest: XCTestCase {

    func testFirstGame() throws {
        // Given
        let service = StatisticServiceImpl(storage: MockStorageFirstGame())
        // When
        let result = service.calculateAndSave(with: GameResultDto(correctAnswers: 10, riddlesCount: 10))
        // Then
        XCTAssertEqual(result.averageValue, 100)
        XCTAssertEqual(result.gamesCount, 1)
        XCTAssertEqual(result.recordRiddlesCount, 10)
        XCTAssertEqual(result.recordValue, 10)
    }

    func testSecondGame() throws {
        // Given
        let service = StatisticServiceImpl(storage: MockStorageSecondGame())
        // When
        let result = service.calculateAndSave(with: GameResultDto(correctAnswers: 4, riddlesCount: 10))
        // Then
        XCTAssertEqual(result.averageValue, 45)
        XCTAssertEqual(result.gamesCount, 2)
        XCTAssertEqual(result.recordRiddlesCount, 10)
        XCTAssertEqual(result.recordValue, 5)
    }
}
