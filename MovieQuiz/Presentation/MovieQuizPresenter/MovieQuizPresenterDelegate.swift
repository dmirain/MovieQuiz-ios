protocol MovieQuizPresenterDelegate: AnyObject {
    func showNextRiddle(riddle: MovieRiddle, num: Int, count: Int)
    func showEndGame(result: GameResultDto, statistic: StatisticDto)
    func showError(error: NetworkError)
    func showPositiveAnswer()
    func showNegativeAnswer()
    func showSplashScrean()
    func hideSplashScrean()
}
