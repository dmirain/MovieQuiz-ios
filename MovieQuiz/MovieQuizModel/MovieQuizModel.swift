protocol MovieQuizModel {
    var delegate: MovieQuizModelDelegat? { get set }

    init(riddleGenerator: RiddleFactory, statisticService: StatisticService)

    func startNewGame()
    func checkAnswer(_ answer: Answer)
}
