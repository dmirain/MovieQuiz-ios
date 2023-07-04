import UIKit

class ResultAlertPresenterImpl: ResultAlertPresenter {
    private weak var delegate: ResultAlertPresenterDelegate?
    
    required init(delegate: ResultAlertPresenterDelegate) {
        self.delegate = delegate
    }
    
    func show(with resultAlertDto: ResultAlertDto) {
        let alert = UIAlertController(
            title: resultAlertDto.headerTitle,
            message: resultAlertDto.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: resultAlertDto.actionTitle, style: .default) { [weak self] _ in
            guard let self = self else {
                return
            }
            self.delegate?.nextGame()
        }
        
        alert.addAction(action)

        delegate?.presentAlert(alert)
    }
}
