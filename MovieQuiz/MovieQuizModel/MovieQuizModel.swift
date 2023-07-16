protocol MovieQuizModel {
    var delegate: MovieQuizModelDelegate? { get set }

    init(riddleGenerator: RiddleFactory, statisticService: StatisticService)

    func startNewGame()
    func checkAnswer(_ answer: Answer)
}
