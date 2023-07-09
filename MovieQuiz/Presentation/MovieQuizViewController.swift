import UIKit

// MARK: - MovieQuizViewController

final class MovieQuizViewController: UIViewController {
    private var movieQuiz: MovieQuizModel
    private var alertPresenter: AlertPresenter
    private var mainPresenter: MovieQuizPresenter

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var blur: UIVisualEffectView!

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("init (nibName: bundle:) has not been implemented")
    }

    required init?(coder: NSCoder) {
        movieQuiz = MovieQuizModelImpl(
            riddleGenerator: RiddleFactoryImpl(
                movieHubGateway: KPGatewayImpl(
                    httpClient: NetworkClientImpl()
                )
            ),
            statisticService: StatisticServiceImpl(
                storage: StatisticStorageImpl.shared
            )
        )
        alertPresenter = AlertPresenterImpl()
        mainPresenter = MovieQuizPresenterImpl()

        super.init(coder: coder)

        movieQuiz.delegate = self
        alertPresenter.delegate = self
        mainPresenter.viewController = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setFonts()
        activityIndicator.hidesWhenStopped = true
        movieQuiz.startNewGame()
    }

    @IBAction private func noButtonClicked() {
        movieQuiz.checkAnswer(.no)
    }

    @IBAction private func yesButtonClicked() {
        movieQuiz.checkAnswer(.yes)
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
}

extension MovieQuizViewController: MovieQuizPresenterDelegate {

    func showNextRiddle(riddle: MovieRiddle, num: Int, count: Int) {
        counterLabel.text = "\(num)/\(count)"
        imageView.image = riddle.image
        textLabel.text = riddle.text

        noButton.isEnabled = true
        yesButton.isEnabled = true

        imageView.layer.borderColor = UIColor.ypBlack.cgColor
        imageView.layer.borderWidth = 0
    }

    func showEndGame(result: GameResultDto, statistic: StatisticDto) {
        alertPresenter.show(with: ResultAlertDto(gameResult: result, statistic: statistic))
    }

    func showError(error: NetworkError) {
        alertPresenter.show(with: ErrorAlertDto(error: error))
    }

    func showPositiveAnswer() {
        imageView.layer.borderColor = UIColor.ypGreen.cgColor
        imageView.layer.borderWidth = 8
    }

    func showNegativeAnswer() {
        imageView.layer.borderColor = UIColor.ypRed.cgColor
        imageView.layer.borderWidth = 8
    }

    func showSplashScrean() {
        activityIndicator.startAnimating()
        blur.alpha = 1
        blur.isHidden = false
    }

    func hideSplashScrean() {
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

extension MovieQuizViewController: MovieQuizModelDelegat {

    func acceptNextGameState(state: GameState) {
        mainPresenter.updateViewState(to: state)
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
