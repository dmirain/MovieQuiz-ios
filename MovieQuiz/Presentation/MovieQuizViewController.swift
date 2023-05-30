import UIKit

// MARK: - MovieQuizViewController

final class MovieQuizViewController: UIViewController {
    private var movieQuiz = MovieQuizModel(
        riddleGenerator: RiddleGenerator(
            imdbGateway: IMDBGateway()
        )
    )
    
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFonts()
        let gameState = movieQuiz.nextGameState()
        updateViewState(to: gameState)
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
    
    private func updateViewState(to state: GameState) {
        switch state {
        case .nextRiddle(let currentRiddle, let riddleNum, let riddleCount):
            counterLabel.text = "\(riddleNum)/\(riddleCount)"
            imageView.image = currentRiddle.image
            textLabel.text = currentRiddle.text
        case .positiveAnswer, .negativeAnswer:
            break
        case .gameEnded(let correctAnswers, let riddlesCount):
            showEndGameAlert(correctAnswers: correctAnswers, riddlesCount: riddlesCount)
        }
        updateImageState(to: state)
        updateButtonsState(to: state)
    }
    
    private func showEndGameAlert(correctAnswers: Int, riddlesCount: Int) {
        let alert = UIAlertController(
            title: "Этот раунд окончен!",
            message: "Ваш результат \(correctAnswers)/\(riddlesCount)",
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Сыграть ещё раз", style: .default) { _ in
            self.movieQuiz.reset()
            let gameState = self.movieQuiz.nextGameState()
            self.updateViewState(to: gameState)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func updateImageState(to state: GameState) {
        switch state {
        case .nextRiddle:
            imageView.layer.borderColor = UIColor.ypBlack.cgColor
            imageView.layer.borderWidth = 0
        case .positiveAnswer:
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            imageView.layer.borderWidth = 8
        case .negativeAnswer:
            imageView.layer.borderColor = UIColor.ypRed.cgColor
            imageView.layer.borderWidth = 8
        case .gameEnded:
            break
        }
    }
    
    private func updateButtonsState(to state: GameState) {
        switch state {
        case .nextRiddle:
            noButton.isEnabled = true
            yesButton.isEnabled = true
        case .negativeAnswer, .positiveAnswer, .gameEnded:
            noButton.isEnabled = false
            yesButton.isEnabled = false
        }

    }
    
    private func performResultButtonClick(with answer: Answer) {
        let gameState = movieQuiz.checkAnswer(answer)
        updateViewState(to: gameState)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let gameState = self.movieQuiz.nextGameState()
            self.updateViewState(to: gameState)
        }
    }
    
    @IBAction private func noButtonClicked() {
        performResultButtonClick(with: .no)
    }
    
    @IBAction private func yesButtonClicked() {
        performResultButtonClick(with: .yes)
    }
}

// MARK: - MovieQuizModel

class MovieQuizModel {
    private let riddleGenerator: RiddleGenerator
    private(set) var movieRiddles: [MovieRiddle] = []
    private(set) var correctAnswers: Int = 0
    private(set) var gameIsEnded: Bool = false
    private(set) var currentRiddleIndex: Int = -1

    init(riddleGenerator: RiddleGenerator) {
        self.riddleGenerator = riddleGenerator
    }
    
    func reset() {
        gameIsEnded = false
        correctAnswers = 0
        currentRiddleIndex = -1
    }
    
    func checkAnswer(_ answer: Answer) -> GameState {
        if movieRiddles[currentRiddleIndex].correctAnswer == answer {
            correctAnswers += 1
            return .positiveAnswer
        } else {
            return .negativeAnswer
        }
    }
    
    func nextGameState() -> GameState {
        currentRiddleIndex += 1
        if currentRiddleIndex == 0 { movieRiddles = riddleGenerator.generate() }

        guard currentRiddleIndex < movieRiddles.count else {
            return .gameEnded(correctAnswers, movieRiddles.count)
        }
        
        let currentRiddle = movieRiddles[currentRiddleIndex]
        return .nextRiddle(currentRiddle, currentRiddleIndex + 1, movieRiddles.count)
    }
}

enum GameState {
    case nextRiddle(MovieRiddle, Int, Int)
    case positiveAnswer
    case negativeAnswer
    case gameEnded(Int, Int)
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
        return Bool.random() ? RiddleSign.more : RiddleSign.less
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
        return "Рейтинг этого фильма \(riddleSign.rawValue) чем \(riddleValue.formatForRiddle())?"
    }
    
    var correctAnswer: Answer {
        let raitingIsLess = rating < riddleValue ? RiddleSign.less : RiddleSign.more
        return raitingIsLess == riddleSign ? Answer.yes : Answer.no
    }
}

enum RiddleSign: String {
    case more = "больше"
    case less = "меньше"
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
        ].shuffled()
    }
}

// MARK: - Double extension

extension Double {
    func formatForRiddle() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 1

        return numberFormatter.string(for: self) ?? ""
    }
}
