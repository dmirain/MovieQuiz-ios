final class MovieQuizPresenterImpl: MovieQuizPresenter {
    weak var viewController: MovieQuizPresenterDelegate?

    private var movieQuiz: MovieQuizModel

    init(viewController: MovieQuizPresenterDelegate? = nil) {
        self.viewController = viewController

        #if TESTS
        let movieHubGateway = MockHubGateway()
        #else
        let httpClient = NetworkClientImpl()
        let movieHubGateway = KPGatewayImpl(httpClient: httpClient)
        #endif

        let riddleGenerator = RiddleFactoryImpl(movieHubGateway: movieHubGateway)
        let statisticService = StatisticServiceImpl(storage: StatisticStorageImpl.shared)

        movieQuiz = MovieQuizModelImpl(riddleGenerator: riddleGenerator, statisticService: statisticService)
        movieQuiz.delegate = self
    }

    func startNewGame() {
        movieQuiz.startNewGame()
    }

    func checkAnswer(_ answer: Answer) {
        movieQuiz.checkAnswer(answer)
    }

    func updateViewState(to state: GameState) {
        guard let viewController else { return }

        switch state {
        case let .nextRiddle(currentRiddle, riddleNum, riddleCount):
            viewController.showNextRiddle(riddle: currentRiddle, num: riddleNum, count: riddleCount)
            if riddleNum == 1 {
                viewController.hideSplashScrean()
            }
        case let .gameEnded(gameResult, statistic):
            viewController.showSplashScrean()
            viewController.showEndGame(result: gameResult, statistic: statistic)
        case let .loadingError(error):
            viewController.showError(error: error)
        case .positiveAnswer:
            viewController.showPositiveAnswer()
        case .negativeAnswer:
            viewController.showNegativeAnswer()
        case .loadingData:
            viewController.showSplashScrean()
        }
    }
}

extension MovieQuizPresenterImpl: MovieQuizModelDelegate {
    func acceptNextGameState(state: GameState) {
        self.updateViewState(to: state)
    }
}
