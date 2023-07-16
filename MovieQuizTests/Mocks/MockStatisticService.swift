import Foundation
@testable import MovieQuiz

struct MockStatisticService: StatisticService {
    static let statistic = StatisticDto(
        gamesCount: 1,
        recordValue: 5,
        recordRiddlesCount: 10,
        recordDate: Date(),
        averageValue: 50
    )

    func calculateAndSave(with result: GameResultDto) -> StatisticDto {
        Self.statistic
    }
}
