protocol StatisticStorage {
    static var shared: StatisticStorage { get }
    func get() -> StatisticDto?
    func set(_ newValue: StatisticDto)
}
