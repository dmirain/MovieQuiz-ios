protocol MovieQuizModel {
    init(delegate: MovieQuizModelDelegat, riddleGenerator: RiddleFactory, statisticService: StatisticService)

    func startNewGame()
    func checkAnswer(_ answer: Answer)
}
