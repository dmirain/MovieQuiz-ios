import XCTest
@testable import MovieQuiz

struct MockNetworkClient: NetworkClient {
    let movie = """
    {
      "rating": {
        "kp": 8.808,
        "imdb": 8.5,
        "filmCritics": 6.8,
        "russianFilmCritics": 100,
        "await": null
      },
      "id": 535341,
      "name": "1+1",
      "poster": {
        "url": "https://st.kp.yandex.net/images/film_big/535341.jpg",
        "previewUrl": "https://st.kp.yandex.net/images/film_iphone/iphone360_535341.jpg"
      }
    }
    """

    func movieResponse(cont: Int) -> String {
        """
         {
          "docs": [
            \([String](repeating: movie, count: cont).joined(separator: ","))
          ],
          "total": 195,
          "limit": 1,
          "page": 1,
          "pages": 195
         }
        """
    }

    func fetch(request: URLRequest) async throws -> Data {
        let stringUrl = request.url?.description ?? ""

        if stringUrl.contains("/v1.3/movie") {
            XCTAssertEqual(
                request.url?.description,
                "https://api.kinopoisk.dev/v1.3/movie" +
                "?selectFields=id%20name%20rating%20poster&limit=250&typeNumber=1&top250=!null"
            )

            return movieResponse(cont: 10).data(using: .utf8)!
        }

        if stringUrl.contains("/images/") {
            XCTAssertEqual(
                request.url?.description,
                "https://st.kp.yandex.net/images/film_iphone/iphone360_535341.jpg"
            )
            return UIImage(named: "Old")!.pngData()!
        }

        throw NetworkError.emptyData
    }
}
