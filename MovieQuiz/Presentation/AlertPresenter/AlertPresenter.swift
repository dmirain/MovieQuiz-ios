import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func presentAlert(_ alert: UIAlertController)
    func performAlertAction(action: AlertAction)
}

protocol AlertPresenter {
    init(delegate: AlertPresenterDelegate)
    func show(with alertDto: AlertDto)
}
