protocol RiddleFactory {
    func generate() async throws -> [MovieRiddle]
}
