//
//  Mocks.swift
//  NewsTests
//
//  Created by Mateusz Mackowiak on 01/05/2023.
//

import Foundation
@testable import API
@testable import News

final class ArticleAPIMock: ArticleAPI {
    var getArticleStub: ((_ locale: Locale?, _ query: String?, _ sources: String?, _ category: API.Category?, _ pageSize: UInt?, _ page: UInt8?) async throws -> [API.Article])!

    func getArticle(locale: Locale?, query: String?, sources: String?, category: API.Category?, pageSize: UInt?, page: UInt8?) async throws -> [API.Article] {
        try await getArticleStub(locale, query, sources, category, pageSize, page)
    }
}

final class ArticleMapperMock: ArticleMapper {
    var mapStub: ((_ articles: [API.Article]) -> [News.Article])!

    func map(_ articles: [API.Article]) -> [News.Article] {
        mapStub(articles)
    }
}

final class ArticleProviderMock: ArticleProvider {
    var articlesStub: ((_ category: News.Category?) async throws -> [News.Article])!
    func articles(category: News.Category?) async throws -> [News.Article] {
        try await articlesStub(category)
    }
}

extension API.Article {
    static func mock() -> API.Article {
        .init(source: .init(id: nil, name: "Nintendo Life"),
              author: "Liam Doolan",
              title: "'The Lara Croft Collection' For Switch Has Been Rated By The ESRB - Nintendo Life",
              description: "Two Tomb Raider spin-offs are due out this year",
              url: URL(string: "https://www.nintendolife.com/news/2023/04/the-lara-croft-collection-for-switch-has-been-rated-by-the-esrb")!,
              urlToImage: URL(string: "https://images.nintendolife.com/59f9897cd722f/1280x720.jpg")!,
              publishedAt: Date(timeIntervalSince1970: 1682849160),
              content: "Image: Crystal Dynamics\r\nBack in October 2021, Square Enix announced it would be releasing Lara Croft and the Guardian of Light and Lara Croft and the Temple of Osiris on the Nintendo Switch. Both ti… [+1786 chars]")
    }
}

extension News.Article {
    static func mock() -> News.Article {
        .init(id: "https://www.nintendolife.com/news/2023/04/the-lara-croft-collection-for-switch-has-been-rated-by-the-esrb",
              source: .init(id: nil, name: "Nintendo Life"),
              author: "Liam Doolan",
              title: "'The Lara Croft Collection' For Switch Has Been Rated By The ESRB - Nintendo Life",
              description: "Two Tomb Raider spin-offs are due out this year",
              url: URL(string: "https://www.nintendolife.com/news/2023/04/the-lara-croft-collection-for-switch-has-been-rated-by-the-esrb")!,
              urlToImage: URL(string: "https://images.nintendolife.com/59f9897cd722f/1280x720.jpg")!,
              publishedAt: Date(timeIntervalSince1970: 1682849160),
              content: "Image: Crystal Dynamics\r\nBack in October 2021, Square Enix announced it would be releasing Lara Croft and the Guardian of Light and Lara Croft and the Temple of Osiris on the Nintendo Switch. Both ti… [+1786 chars]")
    }
}
