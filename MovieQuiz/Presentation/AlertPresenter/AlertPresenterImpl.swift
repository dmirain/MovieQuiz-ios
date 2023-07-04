import UIKit

final class ResultAlertPresenterImpl: AlertPresenter {
    private weak var delegate: AlertPresenterDelegate?

    required init(delegate: AlertPresenterDelegate) {
        self.delegate = delegate
    }

    func show(with alertDto: AlertDto) {
        let alert = UIAlertController(
            title: alertDto.headerTitle,
            message: alertDto.message,
            preferredStyle: .alert
        )

        let action = UIAlertAction(title: alertDto.actionTitle, style: .default) { [weak self] _ in
            guard let self else {
                return
            }
            self.delegate?.performAlertAction(action: alertDto.action)
        }

        alert.addAction(action)

        delegate?.presentAlert(alert)
    }
}
