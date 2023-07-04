import Foundation

enum NetworkError: Error {
    case connectError(innerError: Error)
    case codeError
    case emptyData
    case parseError

    func asText() -> String {
        switch self {
        case .connectError:
            return "Ошибка соединения"
        case .codeError:
            return "Сервер ответил ошибкой"
        case .emptyData:
            return "Сервер не прислал данные"
        case .parseError:
            return "Ошибка разбора данных"
        }
    }

}

struct NetworkClient {
    func fetch(request: URLRequest, handler: @escaping (Result<Data, NetworkError>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Проверяем, пришла ли ошибка
            if let error {
                handler(.failure(.connectError(innerError: error)))
                return
            }

            // Проверяем, что нам пришёл успешный код ответа
            if let response = response as? HTTPURLResponse,
                response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(.codeError))
                return
            }

            // Возвращаем данные
            guard let data else {
                handler(.failure(.emptyData))
                return
            }

            handler(.success(data))
        }

        task.resume()
    }
}
