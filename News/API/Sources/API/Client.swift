//
//  Created on 30/04/2023.
//
//

import Foundation

public protocol Client {
    func fetch(with request: URLRequest) async throws -> ResponseData
}

public struct ResponseData: @unchecked Sendable {
    public let data: Data
    public let statusCode: Int
    public let headers: [AnyHashable: Any]
}

public final class URLSessionClient: Client {
    public enum ClientError: Swift.Error {
        case invalidStatusCode(data: Data?, statusCode: Int)
        case decodeFailure(data: Data?, statusCode: Int, underlying: Error)
        case unknownResponseType(Data?, URLResponse?)
    }

    public let urlSession: URLSession
    public var acceptableStatusCodes = 100..<300

    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    public func fetch(with request: URLRequest) async throws -> ResponseData {
        let (data, response) = try await urlSession.data(for: request)
        guard let urlResponse = response as? HTTPURLResponse else {
            throw ClientError.unknownResponseType(data, response)
        }
        let statusCode = urlResponse.statusCode
        let headers = urlResponse.allHeaderFields
        guard acceptableStatusCodes.contains(statusCode) else {
            throw ClientError.invalidStatusCode(data: data, statusCode: statusCode)
        }
        return ResponseData(data: data, statusCode: statusCode, headers: headers)
    }
}
