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

extension KPMovieItem {
    func toMovieData() -> MovieData {
        MovieData(
            name: self.name,
            rating: self.rating.imdb,
            imageData: (try? Data(contentsOf: URL(string: self.poster.previewUrl)!)) ?? Data()
        )
    }
}

// {
//  "docs": [
//    {
//      "rating": {
//        "kp": 8.808,
//        "imdb": 8.5,
//        "filmCritics": 6.8,
//        "russianFilmCritics": 100,
//        "await": null
//      },
//      "id": 535341,
//      "name": "1+1",
//      "poster": {
//        "url": "https://st.kp.yandex.net/images/film_big/535341.jpg",
//        "previewUrl": "https://st.kp.yandex.net/images/film_iphone/iphone360_535341.jpg"
//      }
//    }
//  ],
//  "total": 195,
//  "limit": 1,
//  "page": 1,
//  "pages": 195
// }
