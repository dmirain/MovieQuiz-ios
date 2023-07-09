final class MovieQuizPresenterImpl: MovieQuizPresenter {
    weak var viewController: MovieQuizPresenterDelegate?

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
