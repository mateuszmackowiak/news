import XCTest
@testable import API

// These test are just for online integrations
final class ArticleApiIntegrationTests: XCTestCase {
    private lazy var tested: NetworkClientArticleApi! = NetworkClientArticleApi(client: URLSessionClient(), apiToken: "<#apiToken#>")

    override func tearDown() {
        tested = nil
        super.tearDown()
    }

    func testResponse() async throws {
        _ = try await tested.getArticle(query: "bitcoin")
    }
}
