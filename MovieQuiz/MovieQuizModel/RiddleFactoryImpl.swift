import UIKit

struct RiddleFactoryImpl: RiddleFactory {
    private let movieHubGateway: MovieHubGateway

    init(movieHubGateway: MovieHubGateway) {
        self.movieHubGateway = movieHubGateway
    }

    func generate(handler: @escaping (Result<[MovieRiddleImpl], NetworkError>) -> Void) {
        movieHubGateway.movies { result in
            switch result {
            case let .success(movies):
                handler(.success(convertResult(movies: movies)))
            case let .failure(error):
                handler(.failure(error))
            }
        }
    }

    private func convertResult(movies: [MovieData]) -> [MovieRiddleImpl] {
        movies.map { movie in
            MovieRiddleImpl(
                name: movie.name,
                rating: movie.rating,
                image: UIImage(data: movie.imageData) ?? UIImage(),
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
