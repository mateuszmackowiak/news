import Foundation
import XCTest
import MockServer

final class POSTTests: XCTestCase {
    private lazy var server = Server(port: Int.random(in: 6000...8000), stubs: [.postTestStub()], unhandledBlock: {
        XCTFail("Unhandled request \($0)")
    })

    override func setUpWithError() throws {
        try server.start()
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try server.stop()
        try super.tearDownWithError()
    }

    func test() throws {
        var request = URLRequest(url: URL(string: "http://localhost:\(server.port)/test")!)
        request.httpMethod = "POST"
        let requestStruct = TestStruct(key: "test")
        request.httpBody = try JSONEncoder().encode(requestStruct)

        var result: (data: Data?, response: URLResponse?, error: Error?)?
        let expectation = self.expectation(description: "complete")

        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            result = (data, response, error)
            expectation.fulfill()
        }).resume()

        wait(for: [expectation], timeout: 3)
        let unwrapped = try XCTUnwrap(result)
        let httpResponse = try XCTUnwrap(unwrapped.response as? HTTPURLResponse)
        let data = try XCTUnwrap(unwrapped.data)
        let responseStruct = try JSONDecoder().decode(TestStruct.self, from: data)
        XCTAssertEqual(responseStruct, requestStruct)
        XCTAssertEqual(httpResponse.statusCode, 200)
    }

    private struct TestStruct: Codable, Hashable {
        let key: String
        var id: UUID = UUID()
    }
}

extension ServerStub {
    public static func postTestStub() -> ServerStub {
        ServerStub(matchingRequest: { $0.method == .POST }, handler: {
            guard let data = $0.body.data else {
                return .failure(statusCode: .badRequest, responseError: ResponseError(code: "Incomplete data", message: "Incomplete data \($0)"))
            }
            return .success(responseBody: data, statusCode: .ok)
        })
    }
}
