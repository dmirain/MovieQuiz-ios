import UIKit

struct RiddleGenerator {
    private let imdbGateway: IMDBGateway
    
    init(imdbGateway: IMDBGateway) {
        self.imdbGateway = imdbGateway
    }
    
    func generate() -> [MovieRiddle] {
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
        return Bool.random() ? RiddleSign.More : RiddleSign.Less
    }
}
