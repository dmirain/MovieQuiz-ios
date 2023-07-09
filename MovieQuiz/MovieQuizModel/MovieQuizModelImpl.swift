import Foundation

final class MovieQuizModelImpl: MovieQuizModel {
    private weak var delegate: MovieQuizModelDelegat?
    private let riddleGenerator: RiddleFactory
    private let statisticService: StatisticService
    private var movieRiddles: [MovieRiddle] = []
    private var correctAnswers: Int = 0
    private var currentRiddleNumber: Int = 0
    private var error: NetworkError?

    required init(delegate: MovieQuizModelDelegat, riddleGenerator: RiddleFactory, statisticService: StatisticService) {
        self.delegate = delegate
        self.riddleGenerator = riddleGenerator
        self.statisticService = statisticService
    }

    func startNewGame() {
        correctAnswers = 0
        currentRiddleNumber = 0
        movieRiddles = []
        error = nil
        nextGameState()
    }

    func checkAnswer(_ answer: Answer) {
        assert(!movieRiddles.isEmpty)
        guard let delegate else { return }

        if movieRiddles[currentRiddleNumber - 1].correctAnswer == answer {
            correctAnswers += 1
            delegate.acceptNextGameState(state: .positiveAnswer)
        } else {
            delegate.acceptNextGameState(state: .negativeAnswer)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            self.nextGameState()
        }
    }

    private func nextGameState() {
        guard let delegate else { return }

        if let error {
            delegate.acceptNextGameState(state: .loadingError(error: error))
            return
        }

        if movieRiddles.isEmpty {
            assert(currentRiddleNumber == 0)

            Task { [weak self] in
                guard let self else { return }
                do {
                    self.movieRiddles = try await self.riddleGenerator.generate()
                } catch let error as NetworkError {
                    self.error = error
                } catch let error {
                    self.error = .unknownError(error: error)
                }

                Task { @MainActor [weak self] in
                    guard let self else { return }
                    self.nextGameState()
                }
            }

            self.delegate?.acceptNextGameState(state: .loadingData)
            return
        }

        currentRiddleNumber += 1

        guard currentRiddleNumber <= movieRiddles.count else {
            let gameResult = GameResultDto(correctAnswers: correctAnswers, riddlesCount: movieRiddles.count)
            let statistic = statisticService.calculateAndSave(with: gameResult)
            delegate.acceptNextGameState(state: .gameEnded(gameResult: gameResult, statistic: statistic))
            return
        }

        let currentRiddle = movieRiddles[currentRiddleNumber - 1]
        delegate.acceptNextGameState(
            state: .nextRiddle(
                riddle: currentRiddle,
                riddleNum: currentRiddleNumber,
                riddlesCount: movieRiddles.count
            )
        )
    }
}
