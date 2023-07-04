class MovieQuizModelImpl: MovieQuizModel {
    private let riddleGenerator: RiddleFactory
    private let statisticService: StatisticService
    private var movieRiddles: [MovieRiddle] = []
    private var correctAnswers: Int = 0
    private var currentRiddleIndex: Int = 0

    required init(riddleGenerator: RiddleFactory, statisticService: StatisticService) {
        self.riddleGenerator = riddleGenerator
        self.statisticService = statisticService
    }
    
    func reset() {
        correctAnswers = 0
        currentRiddleIndex = 0
        movieRiddles = []
    }
    
    func checkAnswer(_ answer: Answer) -> GameState {
        assert(!movieRiddles.isEmpty)
        
        if movieRiddles[currentRiddleIndex].correctAnswer == answer {
            correctAnswers += 1
            return .positiveAnswer
        } else {
            return .negativeAnswer
        }
    }
    
    func nextGameState() -> GameState {
        if movieRiddles.isEmpty {
            assert(currentRiddleIndex == 0)
            movieRiddles = riddleGenerator.generate()
        } else {
            currentRiddleIndex += 1
        }
        
        guard currentRiddleIndex < movieRiddles.count else {
            let gameResult = GameResultDto(correctAnswers: correctAnswers, riddlesCount: movieRiddles.count)
            let statistic = statisticService.calculateAndSave(with: gameResult)
            return .gameEnded(gameResult: gameResult, statistic: statistic)
        }
        
        let currentRiddle = movieRiddles[currentRiddleIndex]
        return .nextRiddle(riddle: currentRiddle, riddleNum: currentRiddleIndex + 1, riddlesCount: movieRiddles.count)
    }
}
