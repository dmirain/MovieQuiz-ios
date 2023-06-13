import UIKit

protocol ResultAlertPresenter {
    init(delegate: ResultAlertPresenterDelegate)
    func show(with resultAlertDto: ResultAlertDto)
}

protocol ResultAlertPresenterDelegate: AnyObject {
    func presentAlert(_ alert: UIAlertController)
    func nextGame()
}
