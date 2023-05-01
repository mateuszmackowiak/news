//
//  ArticleProvider.swift
//  News
//
//  Created by Mateusz Mackowiak on 01/05/2023.
//

import Foundation
import API

typealias Category = API.Category

protocol ArticleProvider {
    func articles(category: Category?) async throws -> [Article]
}

final class APIArticleProvider: ArticleProvider {
    private let api: any ArticleAPI
    private let mapper: any ArticleMapper
    private let locale: Locale

    init(api: any ArticleAPI, mapper: any ArticleMapper, locale: Locale = .current) {
        self.api = api
        self.mapper = mapper
        self.locale = locale
    }

    func articles(category: Category?) async throws -> [Article] {
        do {
            let articles = mapper.map(try await api.getArticle(locale: locale, category: category))
            Log.debug("Received articles \(articles)")
            return articles
        } catch {
            Log.warning("Failed to fetch articles \(error)")
            throw error
        }
    }
}
