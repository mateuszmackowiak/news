//
//  BookmarkStorage.swift
//  News
//
//  Created by Mateusz Mackowiak on 01/05/2023.
//

import Foundation

protocol BookmarkStorage: Sendable {
    func store(articles: [Article])
    func articles() -> [Article]
}

final class UserDefaultBookmarkStorage: BookmarkStorage, @unchecked Sendable {
    private let key: String
    private let userDefaults: UserDefaults
    private let jsonEncoder = JSONEncoder()

    init(userDefaults: UserDefaults, key: String = "UserDefaultBookmarkStorageKey") {
        self.userDefaults = userDefaults
        self.key = key
    }

    func store(articles: [Article]) {
        userDefaults.set(try! jsonEncoder.encode(articles), forKey: key)
    }

    func articles() -> [Article] {
        let data = userDefaults.data(forKey: key)
        return data.flatMap { try? JSONDecoder().decode([Article].self, from: $0) } ?? []
    }
}

@MainActor
final class BookmarkedCache: ObservableObject {
    private let bookmarkStorage: any BookmarkStorage
    @Published private(set) var articles: [Article] = []

    init(bookmarkStorage: any BookmarkStorage) {
        self.bookmarkStorage = bookmarkStorage
        articles = bookmarkStorage.articles()
    }

    func isBookmarked(article: Article) -> Bool {
        articles.contains(article)
    }

    func toggleBookmark(for article: Article) {
        if articles.contains(article) {
            articles.removeAll { $0 == article }
        } else {
            articles.append(article)
        }
        bookmarkStorage.store(articles: articles)
    }
}
