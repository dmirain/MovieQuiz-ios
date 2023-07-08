import Foundation

protocol NetworkClient {
    func fetch(request: URLRequest) async throws -> Data
}

enum NetworkError: Error {
    case connectError(code: URLError.Code)
    case codeError(code: Int)
    case emptyData
    case parseError

    func asText() -> String {
        switch self {
        case let .connectError(code):
            return "Ошибка соединения: \(code.rawValue)"
        case let .codeError(code):
            return "Сервер ответил ошибкой: \(code)"
        case .emptyData:
            return "Сервер не прислал данные"
        case .parseError:
            return "Ошибка разбора данных"
        }
    }
}

struct NetworkClientImpl: NetworkClient {
    func fetch(request: URLRequest) async throws -> Data {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let response = response as? HTTPURLResponse,
                response.statusCode < 200 || response.statusCode >= 300 {
                throw NetworkError.codeError(code: response.statusCode)
            }

            return data
        } catch let error as URLError {
            throw NetworkError.connectError(code: error.code)
        }
    }
}
