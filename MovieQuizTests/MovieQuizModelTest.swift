import XCTest
@testable import MovieQuiz

final class MovieQuizModelTest: XCTestCase, MovieQuizModelDelegate {
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

    func testGameLogic() throws {
        // Given
        let factoryCls = MockRiddleFactory.self
        let model = MovieQuizModelImpl(
            riddleGenerator: MockRiddleFactory(),
            statisticService: MockStatisticService()
        )
        model.delegate = self

        // When
        model.startNewGame()
        nextRiddleExpectation = expectation(description: "nextRiddle")
        waitForExpectations(timeout: 3) // Ждём загрузку данных и следующую загадку

        model.checkAnswer(.yes)
        nextRiddleExpectation = expectation(description: "nextRiddle")
        waitForExpectations(timeout: 2) // Ждём следующую загадку

        model.checkAnswer(.yes)
        nextRiddleExpectation = expectation(description: "gameEnded")
        waitForExpectations(timeout: 2) // Ждём результата игры

        // Then
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
