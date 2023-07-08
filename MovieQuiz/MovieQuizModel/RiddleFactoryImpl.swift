import UIKit

struct RiddleFactoryImpl: RiddleFactory {
    private let movieHubGateway: MovieHubGateway

    init(movieHubGateway: MovieHubGateway) {
        self.movieHubGateway = movieHubGateway
    }

    func generate() async throws -> [MovieRiddle] {
        let moviesData = try await movieHubGateway.movies()
        return convertResult(movies: moviesData)
    }

    private func convertResult(movies: [MovieData]) -> [MovieRiddleImpl] {
        movies.map { movie in
            MovieRiddleImpl(
                name: movie.name,
                rating: movie.rating,
                image: movie.imageData == nil ? UIImage() : UIImage(data: movie.imageData!) ?? UIImage(),
                riddleValue: generateValue(),
                riddleSign: generateSign()
            )
        }
    }

    private func generateValue() -> Double {
        (Double.random(in: 6...10) * 10).rounded() / 10
    }

    private func generateSign() -> RiddleSign {
        Bool.random() ? RiddleSign.more : RiddleSign.less
    }
}
