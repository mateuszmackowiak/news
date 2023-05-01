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
        mapper.map(try await api.getArticle(locale: .current))
    }
}
