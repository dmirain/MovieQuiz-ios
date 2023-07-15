import Foundation

struct KPMovieItem: Decodable {
    let name: String
    let rating: KPMovieRating
    let poster: KPMoviePoster
}

struct KPMovieRating: Decodable {
    let imdb: Double
}

struct KPMoviePoster: Decodable {
    let previewUrl: String
}

struct KPMovieDto: Decodable {
    let docs: [KPMovieItem]
}
