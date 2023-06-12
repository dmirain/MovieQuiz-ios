protocol MovieQuizModel {
    init(riddleGenerator: RiddleFactory, statisticCalculator: StatisticCalculator)
    
    func reset()
    func checkAnswer(_ answer: Answer) -> GameState
    func nextGameState() -> GameState
}
