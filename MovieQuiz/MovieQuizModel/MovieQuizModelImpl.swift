import Foundation

final class MovieQuizModelImpl: MovieQuizModel {
    private weak var delegat: MovieQuizModelDelegat?
    private let riddleGenerator: RiddleFactory
    private let statisticService: StatisticService
    private var movieRiddles: [MovieRiddle] = []
    private var correctAnswers: Int = 0
    private var currentRiddleNumber: Int = 0
    private var error: NetworkError?

    required init(delegat: MovieQuizModelDelegat, riddleGenerator: RiddleFactory, statisticService: StatisticService) {
        self.delegat = delegat
        self.riddleGenerator = riddleGenerator
        self.statisticService = statisticService
    }

    func reset() {
        correctAnswers = 0
        currentRiddleNumber = 0
        movieRiddles = []
        error = nil
    }

    func checkAnswer(_ answer: Answer) {
        assert(!movieRiddles.isEmpty)
        guard let delegat else { return }

        if movieRiddles[currentRiddleNumber - 1].correctAnswer == answer {
            correctAnswers += 1
            delegat.acceptNextGameState(state: .positiveAnswer)
        } else {
            delegat.acceptNextGameState(state: .negativeAnswer)
        }
    }

    func nextGameState() {
        guard let delegat else { return }

        if let error {
            delegat.acceptNextGameState(state: .loadingError(error: error))
            return
        }

        if movieRiddles.isEmpty {
            assert(currentRiddleNumber == 0)
            riddleGenerator.generate { [weak self] result in
                guard let self else { return }

                switch result {
                case let .success(riddles):
                    self.movieRiddles = riddles
                case let .failure(error):
                    self.error = error
                }
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.nextGameState()
                }
            }
            self.delegat?.acceptNextGameState(state: .loadingData)
            return
        }

        currentRiddleNumber += 1

        guard currentRiddleNumber <= movieRiddles.count else {
            let gameResult = GameResultDto(correctAnswers: correctAnswers, riddlesCount: movieRiddles.count)
            let statistic = statisticService.calculateAndSave(with: gameResult)
            delegat.acceptNextGameState(state: .gameEnded(gameResult: gameResult, statistic: statistic))
            return
        }

        let currentRiddle = movieRiddles[currentRiddleNumber - 1]
        delegat.acceptNextGameState(
            state: .nextRiddle(
                riddle: currentRiddle,
                riddleNum: currentRiddleNumber,
                riddlesCount: movieRiddles.count
            )
        )
    }
}
