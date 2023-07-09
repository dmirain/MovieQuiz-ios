protocol MovieQuizPresenter {
    var viewController: MovieQuizPresenterDelegate? { get set }
    func updateViewState(to state: GameState)
}
