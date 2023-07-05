import Foundation

struct KPGatewayImpl: MovieHubGateway {
    private var request: URLRequest {
        var components = URLComponents(string: "https://api.kinopoisk.dev/v1.3/movie")!
        components.queryItems = [
            URLQueryItem(
                name: "selectFields",
                value: ["id", "name", "rating", "poster"].joined(separator: " ")
            ),
            URLQueryItem(name: "limit", value: "250"),
            URLQueryItem(name: "typeNumber", value: "1"),
            URLQueryItem(name: "top250", value: "!null")

        ]
        var request = URLRequest(url: components.url!)
        request.addValue("TOKEN", forHTTPHeaderField: "X-API-KEY")
        request.timeoutInterval = 10 // seconds
        return request
    }

    let httpClient: NetworkClient

    func movies(handler: @escaping (Result<[MovieData], NetworkError>) -> Void) {
        httpClient.fetch(request: request) { result in
            switch result {
            case let .success(data):
                handler(convertData(data: data))
            case let .failure(error):
                handler(.failure(error))
            }
        }
    }

    private func convertData(data: Data) -> Result<[MovieData], NetworkError> {
        guard let moviesDto = data.fromJson(to: KPMovieDto.self) else {
            return .failure(.parseError)
        }
        return .success(moviesDto.docs.shuffled().prefix(10).map { $0.toMovieData() })
    }
}
