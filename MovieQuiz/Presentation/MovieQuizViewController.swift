import UIKit

// MARK: - MovieQuizViewController

final class MovieQuizViewController: UIViewController {
    private var movieQuiz = MovieQuizModel(
        riddleGenerator: RiddleGenerator(
            imdbGateway: IMDBGateway()
        )
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFonts()
        updateView()
    }
    
    private func setFonts() {
        let mediumFont = UIFont(name: "YSDisplay-Medium", size: 20)!
        let boldFont = UIFont(name: "YSDisplay-Bold", size: 23)!
        
        questionLabel.font = mediumFont
        textLabel.font = boldFont
        counterLabel.font = mediumFont
        noButton.titleLabel?.font = mediumFont
        yesButton.titleLabel?.font = mediumFont
    }
    
    private func updateView() {
        if movieQuiz.gameIsEnded {
            showEndGameAlert()
            return
        }

        counterLabel.text = "\(movieQuiz.currentRiddleNum)/\(movieQuiz.movieRiddles.count)"
        imageView.image = movieQuiz.currentRiddle.image
        imageView.layer.borderColor = UIColor.black.cgColor
        textLabel.text = movieQuiz.currentRiddle.text
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
    
    private func showEndGameAlert() {
        let alert = UIAlertController(
            title: "Этот раунд окончен!",
            message: "Ваш результат \(movieQuiz.correctAnswers)/\(movieQuiz.movieRiddles.count)",
            preferredStyle: .alert)

        let action = UIAlertAction(title: "Сыграть ещё раз", style: .default) { _ in
            self.movieQuiz.reset()
            self.updateView()
        }

        alert.addAction(action)

        self.present(alert, animated: true, completion: nil)
    }

    private func updateImageBorder(isPositive: Bool) {
        let color = isPositive ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.borderColor = color
    }
    
    private func performResultButtonClick(with answer: Answer) {
        let result = movieQuiz.checkAnswer(answer)
        updateImageBorder(isPositive: result)
        noButton.isEnabled = false
        yesButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.updateView()
        }
    }
    
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!

    @IBAction private func noButtonClicked() {
        performResultButtonClick(with: .no)
    }
    
    @IBAction private func yesButtonClicked() {
        performResultButtonClick(with: .yes)
    }
}

// MARK: - MovieQuizModel

struct MovieQuizModel {
    private let riddleGenerator: RiddleGenerator
    private(set) var movieRiddles: [MovieRiddle]
    private(set) var correctAnswers: Int
    private(set) var currentRiddle: MovieRiddle
    private(set) var gameIsEnded: Bool = false

    init(riddleGenerator: RiddleGenerator) {
        self.riddleGenerator = riddleGenerator
        movieRiddles = riddleGenerator.generate()
        correctAnswers = 0
        currentRiddle = movieRiddles[0]
    }

    var currentRiddleNum: Int {
        guard let index = movieRiddles.firstIndex(where: { riddle in riddle.name == currentRiddle.name }) else {
            return movieRiddles.count
        }
        return index + 1
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

struct RiddleGenerator {
    private let imdbGateway: IMDBGateway
    
    init(imdbGateway: IMDBGateway) {
        self.imdbGateway = imdbGateway
    }
    
    func generate() -> [MovieRiddle] {
        let movies = imdbGateway.movies()
        return movies.map { movie in
            MovieRiddle(
                name: movie.name,
                rating: movie.rating,
                image: UIImage(named: movie.name) ?? UIImage(),
                riddleValue: generateValue(),
                riddleSign: generateSign()
            )
        }
    }
    
    private func generateValue() -> Double {
        return (Double.random(in: 4...10) * 10).rounded() / 10
    }
    
    private func generateSign() -> RiddleSign {
        return Bool.random() ? RiddleSign.More : RiddleSign.Less
    }
}

struct MovieRiddle {
    let name: String
    let image: UIImage
    private let rating: Double
    private let riddleValue: Double
    private let riddleSign: RiddleSign
    
    init(name: String, rating: Double, image: UIImage, riddleValue: Double, riddleSign: RiddleSign) {
        self.name = name
        self.rating = rating
        self.image = image
        self.riddleValue = riddleValue
        self.riddleSign = riddleSign
    }
    
    var text: String {
        return "Рейтинг этого фильма \(riddleSign.rawValue) чем \(riddleValue)?"
    }
    
    var correctAnswer: Answer {
        let raitingIsLess = rating < riddleValue ? RiddleSign.Less : RiddleSign.More
        return raitingIsLess == riddleSign ? Answer.yes : Answer.no
    }
}

enum RiddleSign: String {
    case More = "больше"
    case Less = "меньше"
}

enum Answer {
    case yes
    case no
}


// MARK: - IMDBGateway

struct IMDBMovie {
    let name: String
    let rating: Double
}

struct IMDBGateway {
    func movies() -> [IMDBMovie] {
        return [
            IMDBMovie(
                name: "The Godfather",
                rating: 9.2
            ),
            IMDBMovie(
                name: "The Dark Knight",
                rating: 9
            ),
            IMDBMovie(
                name: "Kill Bill",
                rating: 8.1
            ),
            IMDBMovie(
                name: "The Avengers",
                rating: 8
            ),
            IMDBMovie(
                name: "Deadpool",
                rating: 8
            ),
            IMDBMovie(
                name: "The Green Knight",
                rating: 6.6
            ),
            IMDBMovie(
                name: "Old",
                rating: 5.8
            ),
            IMDBMovie(
                name: "The Ice Age Adventures of Buck Wild",
                rating: 4.3
            ),
            IMDBMovie(
                name: "Tesla",
                rating: 5.1
            ),
            IMDBMovie(
                name: "Vivarium",
                rating: 5.8
            )
        ]
    }
}
