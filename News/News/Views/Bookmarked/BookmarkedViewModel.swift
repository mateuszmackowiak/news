//
//  BookmarkedViewModel.swift
//  News
//
//  Created by Mateusz Mackowiak on 01/05/2023.
//

import Foundation
import Combine

@MainActor
final class BookmarkedViewModel: ObservableObject {
    private let bookmarkedCache: BookmarkedCache
    private var cancellable: AnyCancellable?
    @Published private(set) var articles: [Article] = []

    init(bookmarkedCache: BookmarkedCache) {
        self.bookmarkedCache = bookmarkedCache
        articles = bookmarkedCache.articles
        cancellable = bookmarkedCache.$articles.sink(receiveValue: { [weak self] articles in
            self?.articles = articles
        })
    }

    func isBookmarked(article: Article) -> Bool {
        bookmarkedCache.isBookmarked(article: article)
    }
}
