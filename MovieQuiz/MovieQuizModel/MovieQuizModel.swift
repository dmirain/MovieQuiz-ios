protocol MovieQuizModel {
    init(delegat: MovieQuizModelDelegat, riddleGenerator: RiddleFactory, statisticService: StatisticService)

    func startNewGame()
    func checkAnswer(_ answer: Answer)
}
