//
//  ArticleDetailsViewModel.swift
//  News
//
//  Created by Mateusz Mackowiak on 01/05/2023.
//

import Foundation

@MainActor
final class ArticleDetailsViewModel: ObservableObject {
    let article: Article
    let bookmarkedCache: BookmarkedCache

    init(article: Article, bookmarkedCache: BookmarkedCache) {
        self.article = article
        self.bookmarkedCache = bookmarkedCache
    }

    func isBookmarked() -> Bool {
        bookmarkedCache.isBookmarked(article: article)
    }

    func bookmarkAction() {
        bookmarkedCache.toggleBookmark(for: article)
    }
}
