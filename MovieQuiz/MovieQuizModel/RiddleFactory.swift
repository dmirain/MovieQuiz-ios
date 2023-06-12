protocol RiddleFactory {
    init(imdbGateway: IMDBGateway)
    func generate() -> [MovieRiddle]
}
