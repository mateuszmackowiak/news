//
//  Article.swift
//  News
//
//  Created by Mateusz Mackowiak on 01/05/2023.
//

import Foundation

public struct Article: Identifiable, Hashable, Sendable {
    public let id: String
    public let source: ArticleSource
    public let author: String?
    public let title: String
    public let description: String?
    public let url: URL
    public let urlToImage: URL?
    public let publishedAt: Date
    public let content: String?
}

public struct ArticleSource: Identifiable, Hashable, Sendable {
    public let id: String?
    public let name: String
}
