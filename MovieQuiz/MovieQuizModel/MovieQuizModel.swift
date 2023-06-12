protocol MovieQuizModel {
    init(riddleGenerator: RiddleFactory, statisticService: StatisticService)
    
    func reset()
    func checkAnswer(_ answer: Answer) -> GameState
    func nextGameState() -> GameState
}
