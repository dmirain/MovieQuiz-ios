import UIKit

// MARK: - MovieQuizViewController

final class MovieQuizViewController: UIViewController {
    private var movieQuiz: MovieQuizModel!
    private var alertPresenter: AlertPresenter!

    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var blur: UIVisualEffectView!

    override func viewDidLoad() {
        initialize()
        super.viewDidLoad()
        setFonts()
        movieQuiz.startNewGame()
    }

    @IBAction private func noButtonClicked() {
        performResultButtonClick(with: .no)
    }
    @IBAction private func yesButtonClicked() {
        performResultButtonClick(with: .yes)
    }
}

private extension MovieQuizViewController {
    func initialize() {
        movieQuiz = MovieQuizModelImpl(
            delegat: self,
            riddleGenerator: RiddleFactoryImpl(
                movieHubGateway: KPGatewayImpl(
                    httpClient: NetworkClient()
                )
            ),
            statisticService: StatisticServiceImpl(
                storage: StatisticStorageImpl.shared
            )
        )
        alertPresenter = ResultAlertPresenterImpl(delegate: self)
    }

    func setFonts() {
        let mediumFont = UIFont(name: "YSDisplay-Medium", size: 20)!
        let boldFont = UIFont(name: "YSDisplay-Bold", size: 23)!

        questionLabel.font = mediumFont
        textLabel.font = boldFont
        counterLabel.font = mediumFont
        noButton.titleLabel?.font = mediumFont
        yesButton.titleLabel?.font = mediumFont
    }

    func updateViewState(to state: GameState) {
        switch state {
        case let .nextRiddle(currentRiddle, riddleNum, riddleCount):
            counterLabel.text = "\(riddleNum)/\(riddleCount)"
            imageView.image = currentRiddle.image
            textLabel.text = currentRiddle.text
        case let .gameEnded(gameResult, statistic):
            alertPresenter.show(with: ResultAlertDto(gameResult: gameResult, statistic: statistic))
        case let .loadingError(error):
            alertPresenter.show(with: ErrorAlertDto(error: error))
        case .positiveAnswer, .negativeAnswer, .loadingData:
            break
        }
        updateImageState(to: state)
        updateButtonsState(to: state)
        updateActivityIndicatorState(to: state)
    }

    func performResultButtonClick(with answer: Answer) {
        movieQuiz.checkAnswer(answer)
    }

    func updateImageState(to state: GameState) {
        if let borderColor = state.imageBorderColor {
            imageView.layer.borderColor = borderColor
        }
        imageView.layer.borderWidth = state.imageBorderWidth
    }

    func updateActivityIndicatorState(to state: GameState) {
        activityIndicator.isHidden = !state.loadingActive

        if state.loadingActive {
            activityIndicator.startAnimating()
            blur.alpha = 1
            blur.isHidden = false
        } else {
            activityIndicator.stopAnimating()
            UIView.animate(
                withDuration: 0.5,
                animations: { [weak self] in
                    guard let self else { return }
                    self.blur.alpha = 0
                },
                completion: { [weak self] _ in
                    guard let self else { return }
                    self.blur.isHidden = true
                }
            )
        }
    }

    func updateButtonsState(to state: GameState) {
        noButton.isEnabled = state.canAnswer
        yesButton.isEnabled = state.canAnswer
    }
}

extension MovieQuizViewController: MovieQuizModelDelegat {
    func acceptNextGameState(state: GameState) {
        updateViewState(to: state)
    }
}

extension MovieQuizViewController: AlertPresenterDelegate {
    func presentAlert(_ alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }

    func performAlertAction(action: AlertAction) {
        switch action {
        case .reset:
            movieQuiz.startNewGame()
        }
    }
}

fileprivate extension GameState {
    var canAnswer: Bool {
        switch self {
        case .nextRiddle:
            return true
        case .negativeAnswer, .positiveAnswer, .gameEnded, .loadingData, .loadingError:
            return false
        }
    }

    var loadingActive: Bool {
        switch self {
        case .loadingData, .loadingError, .gameEnded:
            return true
        case .nextRiddle, .negativeAnswer, .positiveAnswer:
            return false
        }
    }

    var imageBorderColor: CGColor? {
        switch self {
        case .nextRiddle, .loadingData, .loadingError:
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
        case .nextRiddle, .loadingData, .loadingError:
            return 0
        case .positiveAnswer, .negativeAnswer, .gameEnded:
            return 8
        }
    }
}
