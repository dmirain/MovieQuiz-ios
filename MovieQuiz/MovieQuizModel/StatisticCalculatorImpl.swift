import Foundation

struct StatisticCalculatorImpl: StatisticCalculator {
    private let storage: StatisticStorage
    
    init(storage: StatisticStorage) {
        self.storage = storage
    }
    
    func calculateAndSave(with result: GameResultDto) -> StatisticDto {
        guard let storedValue = storage.get() else {
            let newValue = StatisticDto(
                gamesCount: 1,
                recordValue: result.correctAnswers,
                recordDate: Date(),
                averageValue: Double(result.correctAnswers) * 10.0
            )
            storage.set(newValue)
            return newValue
        }

        let newRecord = storedValue.recordValue < result.correctAnswers
        
        let newValue = StatisticDto(
            gamesCount: storedValue.gamesCount + 1,
            recordValue: newRecord ? result.correctAnswers : storedValue.recordValue,
            recordDate: newRecord ? Date() : storedValue.recordDate,
            averageValue: (Double(result.correctAnswers) * 10.0 + storedValue.averageValue) / 2.0
        )
        storage.set(newValue)
        return newValue
    }
}
