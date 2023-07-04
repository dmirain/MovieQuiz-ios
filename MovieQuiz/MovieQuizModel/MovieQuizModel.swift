protocol MovieQuizModel {
    init(delegat: MovieQuizModelDelegat, riddleGenerator: RiddleFactory, statisticService: StatisticService)

    func reset()
    func checkAnswer(_ answer: Answer)
    func nextGameState()
}
