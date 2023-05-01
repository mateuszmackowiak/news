//
//  NewsTests.swift
//  NewsTests
//
//  Created by Mateusz Mackowiak on 30/04/2023.
//


import XCTest
@testable import API
@testable import News

final class APIRepositoryProviderTests: XCTestCase {
    private struct MockError: Error {}

    private lazy var api: ArticleAPIMock! = ArticleAPIMock()
    private lazy var mapper: ArticleMapperMock! = ArticleMapperMock()
    private lazy var tested: APIArticleProvider! = APIArticleProvider(api: api, mapper: mapper)

    override func tearDown() {
        api = nil
        mapper = nil
        tested = nil
        super.tearDown()
    }

    func testProperErrorReturnedFromAPI() async throws {
        api.getArticleStub = { _, _, _, _, _, _ in throw MockError() }

        do {
            _ = try await tested.articles(category: nil, source: nil)
        } catch is MockError {
            print("Valid error returned")
        } catch {
            throw error
        }
    }

    func testProperDefaultParamsArePassedToAPI() async throws {
        var locale: Locale?
        var query: String?
        var sources: String?
        var category: News.Category?
        var pageSize: UInt?
        var page: UInt8?

        api.getArticleStub = {
            locale = $0
            query = $1
            sources = $2
            category = $3
            pageSize = $4
            page = $5
            throw MockError()
        }

        _ = try? await tested.articles(category: nil, source: nil)

        XCTAssertEqual(locale, .current)
        XCTAssertNil(query)
        XCTAssertNil(sources)
        XCTAssertNil(category)
        XCTAssertNil(pageSize)
        XCTAssertNil(page)
    }

    func testProperParamsArePassedToAPI() async throws {
        var sendCategory: News.Category?

        api.getArticleStub = { _, _, _, category, _, _ in
            sendCategory = category
            throw MockError()
        }

        _ = try? await tested.articles(category: .business, source: nil)

        XCTAssertEqual(sendCategory, .business)
    }

    func testSuccessResponseIsMapped() async throws {
        let mockAPIModels = [API.Article.mock(), .mock()]
        let mockAppModels = [News.Article.mock(), .mock()]
        api.getArticleStub = { _, _, _, _, _, _ in
            return mockAPIModels
        }
        var dataToBeMapped: [API.Article]?
        mapper.mapStub = {
            dataToBeMapped = $0
            return mockAppModels
        }

        let returned = try await tested.articles(category: nil, source: nil)

        XCTAssertEqual(dataToBeMapped, mockAPIModels)
        XCTAssertEqual(returned, mockAppModels)
    }
}
