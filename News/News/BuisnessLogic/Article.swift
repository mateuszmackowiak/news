//
//  Article.swift
//  News
//
//  Created by Mateusz Mackowiak on 01/05/2023.
//

import Foundation

public struct Article: Codable, Identifiable, Hashable, Sendable {
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

public struct ArticleSource: Codable, Identifiable, Hashable, Sendable {
    public let id: String?
    public let name: String
}

#if DEBUG
extension Article {
    static let sample = Article(id: "https://www.nintendolife.com/news/2023/04/the-lara-croft-collection-for-switch-has-been-rated-by-the-esrb",
                                source: .init(id: nil, name: "Nintendo Life"),
                                author: "Liam Doolan",
                                title: "'The Lara Croft Collection' For Switch Has Been Rated By The ESRB - Nintendo Life",
                                description: "Two Tomb Raider spin-offs are due out this year",
                                url: URL(string: "https://www.nintendolife.com/news/2023/04/the-lara-croft-collection-for-switch-has-been-rated-by-the-esrb")!,
                                urlToImage: URL(string: "https://images.nintendolife.com/59f9897cd722f/1280x720.jpg")!,
                                publishedAt: Date(timeIntervalSince1970: 1682849160),
                                content: "Image: Crystal Dynamics\r\nBack in October 2021, Square Enix announced it would be releasing Lara Croft and the Guardian of Light and Lara Croft and the Temple of Osiris on the Nintendo Switch. Both ti… [+1786 chars]")
}
#endif
