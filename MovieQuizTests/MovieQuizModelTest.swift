import XCTest
@testable import MovieQuiz

struct MockStatisticService: StatisticService {
    static let statistic = StatisticDto(
        gamesCount: 1,
        recordValue: 5,
        recordRiddlesCount: 10,
        recordDate: Date(),
        averageValue: 50
    )

    func calculateAndSave(with result: GameResultDto) -> StatisticDto {
        Self.statistic
    }
}

struct MockRiddleFactory: RiddleFactory {
    static let image = UIImage()

    static let riddles = [
        MovieRiddleImpl(
            name: "Первый",
            rating: 8.5,
            image: image,
            riddleValue: 7,
            riddleSign: .less
        ),
        MovieRiddleImpl(
            name: "Второй",
            rating: 7,
            image: image,
            riddleValue: 8,
            riddleSign: .less
        )
    ]

    func generate() async throws -> [MovieRiddle] {
        try await Task.sleep(nanoseconds: 2 * NSEC_PER_SEC)
        return Self.riddles
    }
}

final class MovieQuizModelTest: XCTestCase, MovieQuizModelDelegat {
    private var states: [GameState] = []
    private var nextRiddleExpectation: XCTestExpectation!

    override func setUpWithError() throws {
        states = []
    }

    func acceptNextGameState(state: GameState) {
        states.append(state)
        switch state {
        case .nextRiddle, .gameEnded:
            nextRiddleExpectation.fulfill()
        default:
            return
        }
    }

    func testExample() throws {

        let factoryCls = MockRiddleFactory.self
        let model = MovieQuizModelImpl(
            riddleGenerator: MockRiddleFactory(),
            statisticService: MockStatisticService()
        )
        model.delegate = self

        model.startNewGame()
        nextRiddleExpectation = expectation(description: "nextRiddle")
        waitForExpectations(timeout: 3) // Ждём загрузку данных и следующую загадку

        model.checkAnswer(.yes)
        nextRiddleExpectation = expectation(description: "nextRiddle")
        waitForExpectations(timeout: 2) // Ждём следующую загадку

        model.checkAnswer(.yes)
        nextRiddleExpectation = expectation(description: "gameEnded")
        waitForExpectations(timeout: 2) // Ждём результата игры

        XCTAssertEqual(self.states[0], .loadingData)
        XCTAssertEqual(self.states[1], .nextRiddle(
            riddle: factoryCls.riddles[0],
            riddleNum: 1,
            riddlesCount: 2
        ))
        XCTAssertEqual(self.states[2], .negativeAnswer)
        XCTAssertEqual(self.states[3], .nextRiddle(
            riddle: factoryCls.riddles[1],
            riddleNum: 2,
            riddlesCount: 2
        ))
        XCTAssertEqual(self.states[4], .positiveAnswer)
        XCTAssertEqual(self.states[5], .gameEnded(
            gameResult: GameResultDto(correctAnswers: 1, riddlesCount: 2),
            statistic: MockStatisticService.statistic
        ))
    }
}

extension GameState: Equatable {
    public static func == (lhs: GameState, rhs: GameState) -> Bool {
        switch (lhs, rhs) {
        case (.positiveAnswer, .positiveAnswer):
            return true
        case (.negativeAnswer, .negativeAnswer):
            return true
        case (.loadingData, .loadingData):
            return true
        case let (.nextRiddle(riddleL, numL, countL), .nextRiddle(riddleR, numR, countR)):
            return riddleL.name == riddleR.name && numL == numR && countL == countR
        case let (.gameEnded(resultL, statL), .gameEnded(resultR, statR)):
            return resultL.correctAnswers == resultR.correctAnswers && statL.recordValue == statR.recordValue
        default:
            return false
        }
    }
}
