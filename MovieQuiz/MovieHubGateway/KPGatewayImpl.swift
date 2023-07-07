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
        request.timeoutInterval = 1 // seconds
        request.addValue("5TN5HZK-6ATMVTM-GC2SEBP-KFDNH4Q", forHTTPHeaderField: "X-API-KEY")
        return request
    }

    private let httpClient: NetworkClient

    init(httpClient: NetworkClient) {
        self.httpClient = httpClient
    }

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
        guard !moviesDto.docs.isEmpty else { return .failure(.emptyData)}
        return .success(moviesDto.docs.shuffled().prefix(10).map { $0.toMovieData() })
    }
}
