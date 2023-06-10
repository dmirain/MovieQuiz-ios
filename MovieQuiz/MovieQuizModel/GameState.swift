enum GameState {
    case nextRiddle(riddle: MovieRiddleProtocol, riddleNum: Int, riddlesCount: Int)
    case positiveAnswer
    case negativeAnswer
    case gameEnded(correctAnswers: Int, riddlesCount: Int)
}
