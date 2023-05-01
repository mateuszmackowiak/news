import Foundation
import XCTest
import MockServer

final class HTTPServerTests: XCTestCase {
    private lazy var location = Location.random()
    private lazy var server = Server(port: .random(in: 7000...8000), stubs: [.bearerAuthorizationValidator, .contentTypeValidator, .homeLocationGetStub(self.location)], unhandledBlock: {
        XCTFail("Unhandled request \($0)")
    })

    private lazy var url = URL(string: "http://localhost:\(server.port)/user-account-api/v1/me/home-location")!

    override func setUpWithError() throws {
        try server.start()
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try server.stop()
        try super.tearDownWithError()
    }

    func testSimpleSuccess() throws {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let headers = ["authorization": "Bearer \(UUID().uuidString)", "Content-Type": "application/json"]
        request.allHTTPHeaderFields = headers

        var result: (data: Data?, response: URLResponse?, error: Error?)?
        let expectation = self.expectation(description: "complete")

        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            result = (data, response, error)
            expectation.fulfill()
        }).resume()

        let expectation1 = self.expectation(description: "complete")
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            result = (data, response, error)
            expectation1.fulfill()
        }).resume()
        let expectation2 = self.expectation(description: "complete")
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            result = (data, response, error)
            expectation2.fulfill()
        }).resume()
        let expectation3 = self.expectation(description: "complete")
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            result = (data, response, error)
            expectation3.fulfill()
        }).resume()
        let expectation4 = self.expectation(description: "complete")
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            result = (data, response, error)
            expectation4.fulfill()
        }).resume()
        let expectation5 = self.expectation(description: "complete")
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            result = (data, response, error)
            expectation5.fulfill()
        }).resume()

        wait(for: [expectation, expectation1, expectation2, expectation3, expectation4, expectation5], timeout: 3)
        let unwrapped = try XCTUnwrap(result)
        XCTAssertEqual(unwrapped.data, Data("""
        {
          "location": {
            "coordinates": [\(location.latitude), \(location.longitude)],
            "type": "Point"
          }
        }
        """.utf8))
        XCTAssertNil(unwrapped.error)
        let httpResponse = try XCTUnwrap(unwrapped.response as? HTTPURLResponse)
        XCTAssertEqual(httpResponse.statusCode, 200)
    }

    func testMissingAuthorizationHeader() throws {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        var result: (data: Data?, response: URLResponse?, error: Error?)?
        let expectation = self.expectation(description: "complete")

        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            result = (data, response, error)
            expectation.fulfill()
        }).resume()

        wait(for: [expectation], timeout: 3)
        let unwrapped = try XCTUnwrap(result)
        let unwrappedData = try XCTUnwrap(unwrapped.data)

        let responseStruct = try JSONDecoder().decode(ResponseError.self, from: unwrappedData)
        XCTAssertEqual(responseStruct.code, "Missing Authorisation Bearer header")
        XCTAssertNil(unwrapped.error)
        let httpResponse = try XCTUnwrap(unwrapped.response as? HTTPURLResponse)
        XCTAssertEqual(httpResponse.statusCode, 403)
    }

    func testMissingContentTypeHeader() throws {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let heardes = ["authorization": "Bearer \(UUID().uuidString)"]
        request.allHTTPHeaderFields = heardes

        var result: (data: Data?, response: URLResponse?, error: Error?)?
        let expectation = self.expectation(description: "complete")

        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            result = (data, response, error)
            expectation.fulfill()
        }).resume()

        wait(for: [expectation], timeout: 3)
        let unwrapped = try XCTUnwrap(result)
        let unwrappedData = try XCTUnwrap(unwrapped.data)

        let responseStruct = try JSONDecoder().decode(ResponseError.self, from: unwrappedData)
        XCTAssertEqual(responseStruct.code, "Missing Content-Type header")
        XCTAssertNil(unwrapped.error)
        let httpResponse = try XCTUnwrap(unwrapped.response as? HTTPURLResponse)
        XCTAssertEqual(httpResponse.statusCode, 400)
    }

    func testSuccessWithAPIKeyHeader() throws {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let headers = ["Apikey": "", "Content-Type": "application/json"]
        request.allHTTPHeaderFields = headers

        var result: (data: Data?, response: URLResponse?, error: Error?)?
        let expectation = self.expectation(description: "complete")

        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            result = (data, response, error)
            expectation.fulfill()
        }).resume()

        wait(for: [expectation], timeout: 3)
        let unwrapped = try XCTUnwrap(result)
        XCTAssertEqual(unwrapped.data, Data("""
        {
          "location": {
            "coordinates": [\(location.latitude), \(location.longitude)],
            "type": "Point"
          }
        }
        """.utf8))
        XCTAssertNil(unwrapped.error)
        let httpResponse = try XCTUnwrap(unwrapped.response as? HTTPURLResponse)
        XCTAssertEqual(httpResponse.statusCode, 200)
    }

    private struct ResponseError: Decodable, Hashable {
        let code: String
        let message: String
    }
}
