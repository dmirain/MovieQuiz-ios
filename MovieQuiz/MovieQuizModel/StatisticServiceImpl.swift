import Foundation

struct StatisticServiceImpl: StatisticService {
    private let storage: StatisticStorage

    init(storage: StatisticStorage) {
        self.storage = storage
    }

    func calculateAndSave(with result: GameResultDto) -> StatisticDto {
        guard let storedValue = storage.get() else {
            let newValue = StatisticDto(
                gamesCount: 1,
                recordValue: result.correctAnswers,
                recordRiddlesCount: result.riddlesCount,
                recordDate: Date(),
                averageValue: result.asPercentage
            )
            storage.set(newValue)
            return newValue
        }

        let newRecord = storedValue.recordValue < result.correctAnswers

        let newValue = StatisticDto(
            gamesCount: storedValue.gamesCount + 1,
            recordValue: newRecord ? result.correctAnswers : storedValue.recordValue,
            recordRiddlesCount: newRecord ? result.riddlesCount : storedValue.recordRiddlesCount,
            recordDate: newRecord ? Date() : storedValue.recordDate,
            averageValue: (result.asPercentage + storedValue.averageValue) / 2.0
        )
        storage.set(newValue)
        return newValue
    }
}
