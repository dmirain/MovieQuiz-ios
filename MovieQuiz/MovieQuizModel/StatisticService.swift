protocol StatisticService {
    func calculateAndSave(with result: GameResultDto) -> StatisticDto
}
