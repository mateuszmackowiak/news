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
final class TopHeadlinesViewModelTests: XCTestCase {
    private lazy var provider: ArticleProviderMock! = ArticleProviderMock()
    private lazy var tested: TopHeadlinesView.ViewModel! = TopHeadlinesView.ViewModel(provider: provider)
    private var cancellable = Set<AnyCancellable>()

    override func tearDown() {
        provider = nil
        tested = nil
        super.tearDown()
    }

    func testOnAppear() {
        let mocks = [Article.mock(), .mock()]
        let exp = expectation(description: "received")
        provider.articlesStub = { _ in
            mocks
        }

        tested.$articles.dropFirst().sink { _ in
            exp.fulfill()
        }.store(in: &cancellable)

        tested.onAppear()

        wait(for: [exp])
        XCTAssertEqual(try XCTUnwrap(tested.articles).map(\.article), mocks)
    }
}
