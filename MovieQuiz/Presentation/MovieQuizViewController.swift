import UIKit

// MARK: - MovieQuizViewController

final class MovieQuizViewController: UIViewController {
    private var movieQuiz: MovieQuizModel!
    
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    override func viewDidLoad() {
        movieQuiz = MovieQuizModelImpl(
            riddleGenerator: RiddleFactoryImpl(
                imdbGateway: IMDBGatewayImpl()
            ),
            statisticCalculator: StatisticCalculatorImpl(
                storage: StatisticStorageImpl.shared
            )
        )
        super.viewDidLoad()
        setFonts()
        self.nextRiddle()
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
        case .gameEnded(let gameResult, let statistic):
            showEndGameAlert(gameResult: gameResult, statistic: statistic)
        }
        updateImageState(to: state)
        updateButtonsState(to: state)
    }
    
    private func showEndGameAlert(gameResult: GameResultDto, statistic: StatisticDto) {
        let alert = UIAlertController(
            title: "Этот раунд окончен!",
            message: """
                Ваш результат: \(gameResult.correctAnswers)/\(gameResult.riddlesCount)
                Количество сыгранных квизов: \(statistic.gamesCount)
                Рекорд: \(statistic.recordValue)\\10 (\(statistic.recordDate))
                Средняя точность: \(statistic.averageValue.asRiddleNum)%
            """,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Сыграть ещё раз", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.nextRiddle(restartGame: true)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func nextRiddle(restartGame: Bool = false) {
        if restartGame { self.movieQuiz.reset() }
        let gameState = self.movieQuiz.nextGameState()
        self.updateViewState(to: gameState)
    }
    
    private func updateImageState(to state: GameState) {
        if let borderColor = state.imageBorderColor {
            imageView.layer.borderColor = borderColor
        }
        imageView.layer.borderWidth = state.imageBorderWidth
    }
    
    private func updateButtonsState(to state: GameState) {
        noButton.isEnabled = state.canAnswer
        yesButton.isEnabled = state.canAnswer
    }
    
    private func performResultButtonClick(with answer: Answer) {
        let gameState = movieQuiz.checkAnswer(answer)
        updateViewState(to: gameState)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.nextRiddle()
        }
    }
    
    @IBAction private func noButtonClicked() {
        performResultButtonClick(with: .no)
    }
    
    @IBAction private func yesButtonClicked() {
        performResultButtonClick(with: .yes)
    }
}


fileprivate extension GameState {
    var canAnswer: Bool {
        switch self {
        case .nextRiddle:
            return true
        case .negativeAnswer, .positiveAnswer, .gameEnded:
            return false
        }
    }
    
    var imageBorderColor: CGColor? {
        switch self {
        case .nextRiddle:
            return UIColor.ypBlack.cgColor
        case .positiveAnswer:
            return UIColor.ypGreen.cgColor
        case .negativeAnswer:
            return UIColor.ypRed.cgColor
        case .gameEnded:
            return nil
        }
    }

    var imageBorderWidth: CGFloat {
        switch self {
        case .nextRiddle:
            return 0
        case .positiveAnswer, .negativeAnswer, .gameEnded:
            return 8
        }
    }
}
