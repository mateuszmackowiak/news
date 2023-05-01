//
//  ArticleMapper.swift
//  News
//
//  Created by Mateusz Mackowiak on 01/05/2023.
//

import API

protocol ArticleMapper {
    func map(_ articles: [API.Article]) -> [Article]
}

final class DefaultArticleMapper: ArticleMapper {
    func map(_ articles: [API.Article]) -> [Article] {
        articles.map(map)
    }

    private func map(_ article: API.Article) -> Article {
        Article(id: article.url.absoluteString,
             source: map(article.source),
             author: article.author,
             title: article.title,
             description: article.description,
             url: article.url,
             urlToImage: article.urlToImage,
             publishedAt: article.publishedAt,
             content: article.content
        )
    }

    private func map(_ source: API.ArticleSource) -> ArticleSource {
        .init(id: source.id,
              name: source.name)
    }
}
