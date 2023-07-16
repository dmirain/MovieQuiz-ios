protocol MovieQuizPresenter {
    var viewController: MovieQuizPresenterDelegate? { get set }
    func startNewGame()
    func checkAnswer(_ answer: Answer)
    func updateViewState(to state: GameState)
}
