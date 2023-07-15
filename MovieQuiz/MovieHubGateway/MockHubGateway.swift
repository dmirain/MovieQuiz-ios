import UIKit

struct MockHubGateway: MovieHubGateway {
    func movies() async throws -> [MovieData] {
        [
            MovieData(name: "Первый", rating: 8.5, imageData: UIImage(named: "Tesla")!.pngData()!),
            MovieData(name: "Второй", rating: 7, imageData: UIImage(named: "Old")!.pngData()!)
        ]
    }
}
