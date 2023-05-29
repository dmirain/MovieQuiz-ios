import UIKit

struct MovieQuizModel {
    private let riddleGenerator: RiddleGenerator
    private(set) var movieRiddles: [MovieRiddle]
    private(set) var correctAnswers: Int
    private(set) var currentRiddle: MovieRiddle
    private(set) var gameIsEnded: Bool = false

    var currentRiddleNum: Int {
        guard let index = movieRiddles.firstIndex(where: { riddle in riddle.name == currentRiddle.name }) else {
            return movieRiddles.count
        }
        return index + 1
    }

    init(riddleGenerator: RiddleGenerator) {
        self.riddleGenerator = riddleGenerator
        movieRiddles = riddleGenerator.generate()
        correctAnswers = 0
        currentRiddle = movieRiddles[0]
    }
    
    mutating func reset() {
        gameIsEnded = false
        movieRiddles = riddleGenerator.generate()
        correctAnswers = 0
        currentRiddle = movieRiddles[0]
    }
    
    mutating func checkAnswer(_ answer: Answer) -> Bool {
        var result = false
        if currentRiddle.correctAnswer == answer {
            correctAnswers += 1
            result = true
        }
        if currentRiddleNum == movieRiddles.count {
            gameIsEnded = true
        } else {
            currentRiddle = movieRiddles[currentRiddleNum]
        }
        return result
    }
}
