import XCTest
@testable import MovieQuiz

final class RiddleFactoryTest: XCTestCase {

    func testGenerate() async throws {
        // Given
        let factory = RiddleFactoryImpl(movieHubGateway: MockMovieHubGateway())
        // When
        let result = try? await factory.generate()
        // Then
        XCTAssertNotNil(result)
        guard let result else { return }
        XCTAssertEqual(result.count, 1)

        let riddle = result[0]
        XCTAssertTrue(riddle.text.starts(with: "Рейтинг этого фильма"))
        XCTAssertEqual(riddle.name, "Название фильма")
        XCTAssertNil(riddle.image.pngData())
        XCTAssertNoThrow(riddle.correctAnswer)
    }
}
