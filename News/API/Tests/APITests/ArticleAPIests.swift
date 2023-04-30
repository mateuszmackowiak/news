import XCTest
@testable import API

final class ArticleTests: XCTestCase {
    private lazy var apiToken: String! = UUID().uuidString
    private lazy var mockClient: MockClient! = MockClient()
    private lazy var tested: NetworkClientArticleApi! = NetworkClientArticleApi(client: mockClient, apiToken: apiToken)

    override func tearDown() {
        apiToken = nil
        mockClient = nil
        tested = nil
        super.tearDown()
    }

    func testSuccessResponse() async throws {
        let expectedResult = [Article(source: .init(id: "t3n", name: "T3n"),
                                   author: "Kay Nordenbrock",
                                   title: "Energieverbrauch von Bitcoin und Ethereum: Wie Wolkenkratzer neben Himbeere",
                                   description: "Bitcoin verbraucht deutlich mehr Energie als Ethereum. Ethereum mit Proof-of-Stake wiederum benötigt deutlich",
                                   url: URL(string: "https://t3n.de/news/infografik-energieverbrauch-bitcoin-ethereum-vergleich-1548941/")!,
                                   urlToImage: URL(string: "https://t3n.de/news/wp-content/uploads/2023/04/Bitcoin-Ethereum-stromverbrauch-vergleich.jpg")!,
                                   publishedAt: Date(timeIntervalSince1970: 1682773200),
                                   content: "Die University of Cambridge zeigt in einer Analyse, wie viel Energie Ethereum vor und nach dem Wechsel von Proof-of-Work zu Proof-of-Stake verbraucht und wie diese Werte mit dem Verbrauch von Bitcoin… [+2366 chars]")]
        let responseData = try Data(contentsOf: Bundle.module.url(forResource: "SampleResponse", withExtension: "json")!)
        mockClient.fetchStub = { _ in
            return .init(data: responseData, statusCode: 200, headers: [:])
        }

        let response = try await tested.getArticle(query: "324")

        XCTAssertEqual(expectedResult, response)
    }

    func testRequest() async throws {
        var requested: URLRequest?
        mockClient.fetchStub = {
            requested = $0
            return .init(data: Data(), statusCode: 200, headers: [:])
        }
        let query = "324"
        let expectedURLComponents = URLComponents(string: "https://newsapi.org/v2/top-headlines?country=pl&apiKey=\(apiToken!)&query=\(query)&sources=cnn&category=science&pageSize=5&page=2")!

        _ = try? await tested.getArticle(locale: Locale(identifier: "pl_PL"), query: query, sources: "cnn", category: .science, pageSize: 5, page: 2)

        let request = try XCTUnwrap(requested)
        XCTAssertEqual(expectedURLComponents, try XCTUnwrap(URLComponents(url: try XCTUnwrap(request.url), resolvingAgainstBaseURL: false)))
        XCTAssertEqual("GET", request.httpMethod)
        XCTAssertEqual(["Accept": "application/json"], request.allHTTPHeaderFields)
    }

    func testInvalidResponse() async throws {
        mockClient.fetchStub = { _ in
            let data = Data(
                """
                {
                "status": "error",
                "code": "apiKeyMissing",
                "message": "Your API key is missing. Append this to the URL with the apiKey param, or use the x-api-key HTTP header."
                }
                """.utf8)
            return .init(data: data, statusCode: 422, headers: [:])
        }

        do {
            _ = try await tested.getArticle()
        } catch {
            print("error \(error)")
        }
    }
}

final class MockClient: Client {
    var fetchStub: ((_ request: URLRequest) async throws -> ResponseData)!

    init() {}

    func fetch(with request: URLRequest) async throws -> ResponseData {
        try await fetchStub(request)
    }
}


