import XCTest

final class MovieQuizUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
        app = nil
    }

    func testYesButton() throws {
        XCTAssertEqual(app.staticTexts["Counter"].label, "1/2")

        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation

        let button = app.buttons["Yes"]
        XCTAssertTrue(button.isEnabled)
        button.tap()
        XCTAssertFalse(button.isEnabled)
        sleep(1)
        XCTAssertTrue(button.isEnabled)

        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation

        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(app.staticTexts["Counter"].label, "2/2")
    }

    func testNoButton() throws {
        XCTAssertEqual(app.staticTexts["Counter"].label, "1/2")

        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation

        let button = app.buttons["No"]
        XCTAssertTrue(button.isEnabled)
        button.tap()
        XCTAssertFalse(button.isEnabled)
        sleep(1)
        XCTAssertTrue(button.isEnabled)

        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation

        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(app.staticTexts["Counter"].label, "2/2")
    }

    func testResultGame() throws {
        app.buttons["Yes"].tap()
        sleep(1)
        app.buttons["No"].tap()
        sleep(1)

        let alert = app.alerts["Alert"]

        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть ещё раз")
    }

    func testAlertDismiss() throws {
        app.buttons["Yes"].tap()
        sleep(1)
        app.buttons["No"].tap()
        sleep(1)

        let alert = app.alerts["Alert"]
        alert.buttons.firstMatch.tap()
        sleep(1)

        XCTAssertFalse(alert.exists)
        XCTAssertEqual(app.staticTexts["Counter"].label, "1/2")
    }
}
