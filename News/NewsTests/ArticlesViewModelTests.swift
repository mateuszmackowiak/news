//
//  TopHeadlinesUITests.swift
//  NewsTests
//
//  Created by Mateusz Mackowiak on 01/05/2023.
//

import XCTest
import Combine
@testable import News

@MainActor
final class ArticlesViewTests: XCTestCase {
    private lazy var provider: ArticleProviderMock! = ArticleProviderMock()
    private lazy var bookmarkStorage: BookmarkStorageMock! = BookmarkStorageMock()
    private lazy var tested: ArticlesViewModel! = ArticlesViewModel(provider: provider, bookmarkedCache: BookmarkedCache(bookmarkStorage: bookmarkStorage))
    private var cancellable = Set<AnyCancellable>()

    override func tearDown() {
        provider = nil
        bookmarkStorage = nil
        tested = nil
        super.tearDown()
    }

    func testOnAppear() {
        let mocks = [Article.mock(), .mock()]
        let exp = expectation(description: "received")
        bookmarkStorage.articlesStub = { [] }
        provider.articlesStub = { _, _ in
            mocks
        }

        tested.$articles.dropFirst().sink { _ in
            exp.fulfill()
        }.store(in: &cancellable)

        tested.onAppear()

        wait(for: [exp], timeout: 10)
        XCTAssertEqual(try XCTUnwrap(tested.articles).map(\.article), mocks)
    }
}
