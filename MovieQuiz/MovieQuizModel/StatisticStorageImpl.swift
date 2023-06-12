import Foundation

struct StatisticStorageImpl: StatisticStorage {
    static let shared: StatisticStorage = StatisticStorageImpl()
    
    private let storageKey = "statisticData"
    private let userDefaults = UserDefaults.standard
    
    func get() -> StatisticDto? {
        guard let jsonData = userDefaults.data(forKey: storageKey) else { return nil }
        guard let dto = jsonData.fromJson(to: StatisticDto.self) else { return nil }
        return dto
    }
    
    func set(_ newValue: StatisticDto) {
        guard let jsonData = Data.toJsonData(from: newValue) else { return }
        userDefaults.set(jsonData, forKey: storageKey)
    }
}

