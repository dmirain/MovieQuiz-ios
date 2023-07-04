protocol MovieHubGateway {
    func movies(handler: @escaping (Result<[MovieData], NetworkError>) -> Void)
}
