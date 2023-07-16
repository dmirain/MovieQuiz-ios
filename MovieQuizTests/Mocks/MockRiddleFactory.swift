import UIKit
import Foundation
@testable import MovieQuiz

struct MockRiddleFactory: RiddleFactory {
    static let image = UIImage()

    static let riddles = [
        MovieRiddleImpl(
            name: "Первый",
            rating: 8.5,
            image: image,
            riddleValue: 7,
            riddleSign: .less
        ),
        MovieRiddleImpl(
            name: "Второй",
            rating: 7,
            image: image,
            riddleValue: 8,
            riddleSign: .less
        )
    ]

    func generate() async throws -> [MovieRiddle] {
        try await Task.sleep(nanoseconds: 2 * NSEC_PER_SEC)
        return Self.riddles
    }
}
