import Foundation

public struct ResponseError: Encodable, Hashable {
    public let code: String
    public let message: String

    public init(code: String, message: String) {
        self.code = code
        self.message = message
    }
}

open class ServerStub {
    public enum Response {
        case success(responseBody: Data, statusCode: HTTPResponseStatus = .ok, contentType: String = "application/json", headers: [String: String] = [:])
        case failure(statusCode: HTTPResponseStatus, responseError: ResponseError)

        public init(catching body: () throws -> Data) {
            do {
                self = .success(responseBody: try body(), statusCode: .ok)
            } catch {
                self = .failure(statusCode: .badRequest, responseError: ResponseError(code: "\((error as NSError).domain)_\((error as NSError).code)", message: String(describing: error)))
            }
        }

        public static func success<T: Encodable>(response: T, statusCode: HTTPResponseStatus = .ok, contentType: String = "application/json", headers: [String: String] = [:]) -> Response {
            let data = try! JSONEncoder().encode(response)
            return .success(responseBody: data, statusCode: statusCode, contentType: contentType, headers: headers)
        }
    }

    public var matchingRequest: (HTTPRequest) -> Bool
    public var handler: (HTTPRequest) -> Response?

    /// Return `nil` response if You don't want to handle the request.
    public init(matchingRequest: @escaping (HTTPRequest) -> Bool, handler: @escaping (HTTPRequest) -> Response?) {
        self.matchingRequest = matchingRequest
        self.handler = handler
    }

    public init(matchingRequest: @escaping (HTTPRequest) -> Bool, returningFileAt fileURL: @escaping @autoclosure () -> URL) {
        self.matchingRequest = matchingRequest
        self.handler = { _ in .success(responseBody: try! Data(contentsOf: fileURL())) }
    }

    public init(matchingRequest: @escaping (HTTPRequest) -> Bool, returning data: @escaping @autoclosure () -> Data) {
        self.matchingRequest = matchingRequest
        self.handler = { _ in .success(responseBody: data()) }
    }

    public init(matchingRequest: @escaping (HTTPRequest) -> Bool, returning string: @escaping @autoclosure () -> String) {
        self.matchingRequest = matchingRequest
        self.handler = { _ in .success(responseBody: Data(string().utf8)) }
    }

    public init<T: Encodable>(matchingRequest: @escaping (HTTPRequest) -> Bool, returning response: @escaping @autoclosure () -> T) {
        self.matchingRequest = matchingRequest
        self.handler = { _ in Response(catching: { try JSONEncoder().encode(response()) }) }
    }

    public init(matchingRequest: @escaping (HTTPRequest) -> Bool, failing statusCode: @escaping @autoclosure () -> HTTPResponseStatus, responseError: @escaping @autoclosure () -> ResponseError = ResponseError(code: UUID().uuidString, message: UUID().uuidString)) {
        self.matchingRequest = matchingRequest
        self.handler = { _ in .failure(statusCode: statusCode(), responseError: responseError()) }
    }
}

public extension ServerStub {
    static let bearerAuthorizationValidator = BearerAuthorizationValidator()
    static let contentTypeValidator = ContentTypeValidator()
}

public final class BearerAuthorizationValidator: ServerStub {
    public init() {
        super.init(matchingRequest: { _ in true }) {
            guard let authorizationHeader = ($0.headers["Authorization"].first ?? $0.headers["authorization"].first), authorizationHeader.hasPrefix("Bearer ") else {
                if $0.headers["Apikey"].first != nil {
                    return nil
                }
                return .failure(statusCode: .forbidden, responseError: ResponseError(code: "Missing Authorisation Bearer header", message: "Missing Authorisation Bearer header in \($0)"))
            }
            return nil
        }
    }
}

public final class ContentTypeValidator: ServerStub {
    public let supportedTypes: [String]

    public init(supportedTypes: [String] = ["application/json", "multipart/form-data"]) {
        self.supportedTypes = supportedTypes

        super.init(matchingRequest: { _ in true }) { head in
            if head.method == .GET, let header = head.headers["Content-Type"].first {
                for supportedType in supportedTypes {
                    if header.hasPrefix(supportedType) {
                        return nil
                    }
                }
            }
            return .failure(statusCode: .badRequest, responseError: ResponseError(code: "Missing Content-Type header", message: "Request \(head) must provide a valid `Content-Type` header"))
        }
    }
}
