@testable import MovieQuiz

struct MockMovieHubGateway: MovieHubGateway {
    func movies() async throws -> [MovieData] {
        [
            MovieData(
                name: "Название фильма",
                rating: 8.5,
                imageData: nil
            )
        ]
    }
}
