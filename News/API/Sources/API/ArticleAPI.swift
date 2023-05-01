//
//  Created on 30/04/2023.
//
//

import Foundation

public protocol ArticleAPI {
    func getArticle(locale: Locale?, query: String?, sources: String?, category: Category?, pageSize: UInt?, page: UInt8?) async throws -> [Article]
}

public extension ArticleAPI {
    func getArticle(locale: Locale? = nil, query: String? = nil, sources: String? = nil, category: Category? = nil, pageSize: UInt? = nil, page: UInt8? = nil) async throws -> [Article] {
        try await getArticle(locale: locale, query: query, sources: sources, category: category, pageSize: pageSize, page: page)
    }
}

public final class NetworkClientArticleApi: ArticleAPI {
    public enum APIError: Error {
        case unableToCreateURLComponents(url: URL)
        case unableToCreateURLFromComponents(URLComponents)
    }
    private struct ResponseContainer: Decodable {
        let status: String
        let totalResults: Int?
        let articles: [Article]
    }
    let client: Client
    let url: URL
    let apiToken: String

    lazy var jsonDecode: JSONDecoder = {
        $0.dateDecodingStrategy = .iso8601
        return $0
    }(JSONDecoder())
    lazy var dateFormatter = ISO8601DateFormatter()

    public init(client: Client, url: URL? = nil, apiToken: String) {
        self.client = client
        self.url = url ?? URL(string: "https://newsapi.org/v2/top-headlines")!
        self.apiToken = apiToken
    }

    public func getArticle(locale: Locale?, query: String?, sources: String?, category: Category?, pageSize: UInt?, page: UInt8?) async throws -> [Article] {
        guard var baseURLComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw APIError.unableToCreateURLComponents(url: url)
        }
        let locale = (locale ?? Locale.current)
        let country = locale.regionCode?.lowercased() ?? locale.regionCode
        var queryItems = [
            URLQueryItem(name: "country", value: country),
            URLQueryItem(name: "apiKey", value: apiToken),
        ]

        if let query {
            queryItems.append(.init(name: "query", value: query))
        }
        if let sources {
            queryItems.append(.init(name: "sources", value: sources))
        }
        if let category {
            queryItems.append(.init(name: "category", value: category.rawValue))
        }
        if let pageSize {
            queryItems.append(.init(name: "pageSize", value: String(pageSize)))
        }
        if let page {
            queryItems.append(.init(name: "page", value: String(page)))
        }

        baseURLComponents.queryItems = queryItems
        guard let url = baseURLComponents.url else {
            throw APIError.unableToCreateURLFromComponents(baseURLComponents)
        }
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let response = try await client.fetch(with: request)
        return try jsonDecode.decode(ResponseContainer.self, from: response.data).articles
    }
}
