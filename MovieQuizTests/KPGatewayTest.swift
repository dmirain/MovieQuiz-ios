import XCTest
@testable import MovieQuiz

final class KPGatewayTest: XCTestCase {

    func testFetchTenMovies() async throws {
        // Given
        let kpClient = KPGatewayImpl(httpClient: MockNetworkClient())
        // When
        let result = try? await kpClient.movies()
        // Then
        XCTAssertNotNil(result)
        guard let result else { return }
        XCTAssertEqual(result.count, 10)
        XCTAssertEqual(result[0].rating, 8.5)
    }
}
