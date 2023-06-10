import UIKit

protocol RiddleFactoryProtocol {
    init(imdbGateway: IMDBGatewayProtocol)
    func generate() -> [MovieRiddleProtocol]
}

struct RiddleFactory: RiddleFactoryProtocol {
    private let imdbGateway: IMDBGatewayProtocol
    
    init(imdbGateway: IMDBGatewayProtocol) {
        self.imdbGateway = imdbGateway
    }
    
    func generate() -> [MovieRiddleProtocol] {
        let movies = imdbGateway.movies()
        return movies.map { movie in
            MovieRiddle(
                name: movie.name,
                rating: movie.rating,
                image: UIImage(named: movie.name) ?? UIImage(),
                riddleValue: generateValue(),
                riddleSign: generateSign()
            )
        }
    }
    
    private func generateValue() -> Double {
        return (Double.random(in: 4...10) * 10).rounded() / 10
    }
    
    private func generateSign() -> RiddleSign {
        return Bool.random() ? RiddleSign.more : RiddleSign.less
    }
}
