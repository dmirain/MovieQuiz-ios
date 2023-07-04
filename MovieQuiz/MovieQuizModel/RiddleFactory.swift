protocol RiddleFactory {
    init(movieHubGateway: MovieHubGateway)
    func generate(handler: @escaping (Result<[MovieRiddleImpl], NetworkError>) -> Void)
}
