protocol RiddleFactory {
    init(movieHubGateway: MovieHubGateway)
    func generate() async throws -> [MovieRiddle]
}
