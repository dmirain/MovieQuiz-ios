import XCTest
@testable import MovieQuiz

struct MockMovieHub: MovieHubGateway {
    func movies() async throws -> [MovieData] {
        [
            MovieData(
                name: "Название фильма",
                rating: 8.5,
                imageData: nil
            )
        ]
    }
}

final class RiddleFactoryTest: XCTestCase {

    func testGenerate() async throws {
        let factory = RiddleFactoryImpl(movieHubGateway: MockMovieHub())
        let result = try? await factory.generate()
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
