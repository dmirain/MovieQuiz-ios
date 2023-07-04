import UIKit

struct MovieRiddleImpl: MovieRiddle {
    let name: String
    let image: UIImage
    private let rating: Double
    private let riddleValue: Double
    private let riddleSign: RiddleSign

    var text: String {
        "Рейтинг этого фильма \(riddleSign.rawValue) чем \(riddleValue.asRiddleNum)?"
    }

    var correctAnswer: Answer {
        let raitingIsLess = rating < riddleValue ? RiddleSign.less : RiddleSign.more
        return raitingIsLess == riddleSign ? Answer.yes : Answer.no
    }

    init(name: String, rating: Double, image: UIImage, riddleValue: Double, riddleSign: RiddleSign) {
        self.name = name
        self.rating = rating
        self.image = image
        self.riddleValue = riddleValue
        self.riddleSign = riddleSign
    }
}
