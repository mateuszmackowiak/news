//
//  ArticleProvider.swift
//  News
//
//  Created by Mateusz Mackowiak on 01/05/2023.
//

import API

protocol ArticleProvider {
    func articles() async throws -> [Article]
}

final class APIArticleProvider: ArticleProvider {
    private let api: any ArticleAPI
    private let mapper: any ArticleMapper

    init(api: any ArticleAPI, mapper: any ArticleMapper) {
        self.api = api
        self.mapper = mapper
    }

    func articles() async throws -> [Article] {
        do {
            let articles = mapper.map(try await api.getArticle(locale: .init(identifier: "en_US"), category: .technology))
            Log.debug("Received articles \(articles)")
            return articles
        } catch {
            Log.warning("Failed to fetch articles \(error)")
            throw error
        }
    }
}
