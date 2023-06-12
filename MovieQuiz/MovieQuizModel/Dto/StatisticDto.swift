import Foundation

struct StatisticDto: Codable {
    let gamesCount: Int
    let recordValue: Int
    let recordDate: Date
    let averageValue: Double
}
