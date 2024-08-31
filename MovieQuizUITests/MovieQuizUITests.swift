import XCTest
@testable import MovieQuiz

final class MovieQuizUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }

    func testYesButton() throws {
        sleep(2)
        let firstPosterImage = app.images["Poster"].screenshot().pngRepresentation
        
        app.buttons["Yes"].tap()
        sleep(2)
        
        let secondPosterImage = app.images["Poster"].screenshot().pngRepresentation
        let indexLabel = app.staticTexts["Index"]
        
        // Проверка перехода к следующему вопросу
        XCTAssertNotEqual(firstPosterImage, secondPosterImage)
        // Проверка отображения корректного номера вопроса
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testNoButton() throws {
        sleep(2)
        let firstPosterImage = app.images["Poster"].screenshot().pngRepresentation
        
        app.buttons["No"].tap()
        sleep(2)
        
        let secondPosterImage = app.images["Poster"].screenshot().pngRepresentation
        let indexLabel = app.staticTexts["Index"]
        
        // Проверка перехода к следующему вопросу
        XCTAssertNotEqual(firstPosterImage, secondPosterImage)
        // Проверка отображения корректного номера вопроса
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testAlertAppearing() throws {
        sleep(2)
        for _ in 0...9 {
            app.buttons["Yes"].tap()
            sleep(2)
        }
        
        let alert = app.alerts.firstMatch
        
        // Проверка наличие алерта
        XCTAssertTrue(alert.exists)
        // Проверка текста заголовка и кнопки
        XCTAssertEqual(alert.label, "Этот раунд окончен!")
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть еще раз")
    }
    
    func testAlertButton() throws {
        sleep(2)
        for _ in 0...8 {
            app.buttons["Yes"].tap()
            sleep(2)
        }
        let lastPosterImage = app.images["Poster"].screenshot().pngRepresentation
        app.buttons["Yes"].tap()
        
        let alert = app.alerts.firstMatch
        
        alert.buttons.firstMatch.tap()
        sleep(2)
        
        // Проверка отсутствия алерта
        XCTAssertFalse(alert.exists)
        
        let firstPosterImage = app.images["Poster"].screenshot().pngRepresentation
        let indexLabel = app.staticTexts["Index"]
        
        // Проверка обновления вопросов в новом раунде
        XCTAssertNotEqual(lastPosterImage, firstPosterImage)
        // Проверка обновления счетчика вопросов
        XCTAssertEqual(indexLabel.label, "1/10")
    }
}
