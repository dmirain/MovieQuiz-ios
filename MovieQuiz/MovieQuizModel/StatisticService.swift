protocol StatisticService {
    init(storage: StatisticStorage)
    func calculateAndSave(with result: GameResultDto) -> StatisticDto
}
