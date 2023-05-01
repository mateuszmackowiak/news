//
//  ServerStub.swift
//  NewsUITests
//
//  Created by Mateusz Mackowiak on 01/05/2023.
//

import Foundation
import MockServer

typealias Server = MockServer.Server
typealias ServerStub = MockServer.ServerStub

extension ServerStub {
    static func articles() -> ServerStub {
        ServerStub(matchingRequest: { request in
            request.uri.starts(with: "/v2/top-headlines?")
        }, returning: try! Data(contentsOf: Bundle(for: NewsUITests.self).url(forResource: "ArticlesSampleResponse", withExtension: "json")!))
    }

    static func sources() -> ServerStub {
        ServerStub(matchingRequest: { request in
            request.uri.starts(with: "/v2/top-headlines/sources")
        }, returning: try! Data(contentsOf: Bundle(for: NewsUITests.self).url(forResource: "SourcesSampleResponse", withExtension: "json")!))
    }
}
