protocol MovieQuizModelProtocol {
    init(riddleGenerator: RiddleFactoryProtocol)
    
    func reset()
    func checkAnswer(_ answer: Answer) -> GameState
    func nextGameState() -> GameState
}


class MovieQuizModel: MovieQuizModelProtocol {
    private let riddleGenerator: RiddleFactoryProtocol
    private var movieRiddles: [MovieRiddleProtocol] = []
    private var correctAnswers: Int = 0
    private var gameIsEnded: Bool = false
    private var currentRiddleIndex: Int = 0

    required init(riddleGenerator: RiddleFactoryProtocol) {
        self.riddleGenerator = riddleGenerator
    }
    
    func reset() {
        gameIsEnded = false
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
            return .gameEnded(correctAnswers: correctAnswers, riddlesCount: movieRiddles.count)
        }
        
        let currentRiddle = movieRiddles[currentRiddleIndex]
        return .nextRiddle(riddle: currentRiddle, riddleNum: currentRiddleIndex + 1, riddlesCount: movieRiddles.count)
    }
}
