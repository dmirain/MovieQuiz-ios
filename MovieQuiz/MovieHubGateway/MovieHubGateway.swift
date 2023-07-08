protocol MovieHubGateway {
    func movies() async throws -> [MovieData]
}
