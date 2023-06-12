protocol MovieQuizModel {
    init(riddleGenerator: RiddleFactory)
    
    func reset()
    func checkAnswer(_ answer: Answer) -> GameState
    func nextGameState() -> GameState
}
