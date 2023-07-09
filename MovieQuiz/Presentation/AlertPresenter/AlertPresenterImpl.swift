import UIKit

final class AlertPresenterImpl: AlertPresenter {
    weak var delegate: AlertPresenterDelegate?

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
