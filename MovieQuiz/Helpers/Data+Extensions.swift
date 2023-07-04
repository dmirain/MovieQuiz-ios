import Foundation

private let decoder = JSONDecoder()
private let encoder = JSONEncoder()

extension Data {
    func fromJson<T: Decodable>(to dtoType: T.Type) -> T? {
        return try? decoder.decode(dtoType, from: self)
    }

    static func toJson<T: Encodable>(from dto: T) -> Data? {
        return try? encoder.encode(dto)
    }
}
