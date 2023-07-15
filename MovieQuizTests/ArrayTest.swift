import XCTest
@testable import MovieQuiz

final class ArrayTest: XCTestCase {
    func testGetValueInRange() throws { // тест на успешное взятие элемента по индексу
        // Given
        let array: Array = [1, 2]
        // When
        let result = array[safe: 1]
        // Then
        XCTAssertEqual(result, 2)
    }

    func testGetValueOutOfRange() throws { // тест на взятие элемента по неправильному индексу
        // Given
        let array: Array = [1, 2]
        // When
        let result = array[safe: 10]
        // Then
        XCTAssertNil(result)
    }
}
