import UIKit

final class MovieQuizViewController: UIViewController {
    private var movieQuiz = MovieQuizModel(
        riddleGenerator: RiddleGenerator(
            imdbGateway: IMDBGateway()
        )
    )
    
    // MARK: - Lifecycle
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
