struct ResultAlertDto {
    private let gameResult: GameResultDto
    private let statistic: StatisticDto

    let headerTitle = "Этот раунд окончен!"
    let actionTitle = "Сыграть ещё раз"
    var message: String {
        """
            Ваш результат: \(gameResult.correctAnswers)/\(gameResult.riddlesCount)
            Количество сыгранных квизов: \(statistic.gamesCount)
            Рекорд: \(statistic.recordValue)/10 (\(statistic.recordDate.dateTimeString))
            Средняя точность: \(statistic.averageValue.asRiddleNum)%
        """
    }

    init(gameResult: GameResultDto, statistic: StatisticDto) {
        self.gameResult = gameResult
        self.statistic = statistic
    }
}
