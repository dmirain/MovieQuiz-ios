enum GameState {
    case nextRiddle(riddle: MovieRiddle, riddleNum: Int, riddlesCount: Int)
    case positiveAnswer
    case negativeAnswer
    case gameEnded(gameResult: GameResultDto, statistic: StatisticDto)
    case loadingData
    case loadingError(error: NetworkError)
}
