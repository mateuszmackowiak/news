//
//  File.swift
//  
//
//  Created by Mateusz Mackowiak on 01/05/2023.
//

import Foundation

public protocol SourceAPI {
    func getSources(country: String?, category: Category?) async throws -> [Source]
}

public final class NetworkClientSourceAPI: SourceAPI {
    public enum APIError: Error {
        case unableToCreateURLComponents(url: URL)
        case unableToCreateURLFromComponents(URLComponents)
    }
    private struct ResponseContainer: Decodable {
        let status: String
        let sources: [Source]
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
        self.url = url ?? URL(string: "https://newsapi.org/v2/top-headlines/sources")!
        self.apiToken = apiToken
    }

    public func getSources(country: String?, category: Category?) async throws -> [Source] {
        guard var baseURLComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw APIError.unableToCreateURLComponents(url: url)
        }
        var queryItems = [
            URLQueryItem(name: "apiKey", value: apiToken),
        ]

        if let country {
            queryItems.append(.init(name: "country", value: country))
        }
        if let category {
            queryItems.append(.init(name: "category", value: category.rawValue))
        }

        baseURLComponents.queryItems = queryItems
        guard let url = baseURLComponents.url else {
            throw APIError.unableToCreateURLFromComponents(baseURLComponents)
        }
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let response = try await client.fetch(with: request)
        return try jsonDecode.decode(ResponseContainer.self, from: response.data).sources
    }
}
