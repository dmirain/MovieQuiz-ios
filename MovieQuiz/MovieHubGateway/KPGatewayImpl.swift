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
        request.timeoutInterval = 2 // seconds
        request.addValue("5TN5HZK-6ATMVTM-GC2SEBP-KFDNH4Q", forHTTPHeaderField: "X-API-KEY")
        return request
    }

    private let httpClient: NetworkClient

    init(httpClient: NetworkClient) {
        self.httpClient = httpClient
    }

    func movies() async throws -> [MovieData] {
        let moviesRawData = try await httpClient.fetch(request: request)
        return try await convertData(data: moviesRawData)
    }

    private func convertData(data: Data) async throws -> [MovieData] {
        guard let moviesDto = data.fromJson(to: KPMovieDto.self) else {
            throw NetworkError.parseError
        }
        guard !moviesDto.docs.isEmpty else { throw NetworkError.emptyData }

        let moviesWithUrls = Array(
            moviesDto.docs
            .shuffled()
            .filter { $0.url != nil }
            .prefix(10)
        )

        guard moviesWithUrls.count == 10 else { throw NetworkError.emptyData }

        return await convertMovieItems(moviesWithUrls)
    }

    private func convertMovieItems(_ movieItems: [KPMovieItem]) async -> [MovieData] {
        var result = [MovieData]()
        await withTaskGroup(of: MovieData.self) { group in
            movieItems.forEach { movieItem in
                group.addTask {
                    let imageData = await movieItem.loadImage(httpClient: httpClient)
                    return MovieData(
                        name: movieItem.name,
                        rating: movieItem.rating.imdb,
                        imageData: imageData
                    )
                }
            }

            for await movieData in group {
                result.append(movieData)
            }
        }
        return result
    }
}

private extension KPMovieItem {
    var url: URL? { URL(string: poster.previewUrl) }

    func loadImage(httpClient: NetworkClient) async -> Data? {
        var imageRequest = URLRequest(url: url!)
        imageRequest.timeoutInterval = 2
        return try? await httpClient.fetch(request: imageRequest)
    }
}
