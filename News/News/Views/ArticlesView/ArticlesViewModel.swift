//
//  TopHeadlinesViewModel.swift
//  News
//
//  Created by Mateusz Mackowiak on 01/05/2023.
//

import Foundation
import Combine

@MainActor
final class ArticlesViewModel: ObservableObject {
    private var provider: any ArticleProvider
    private var bookmarkedCache: BookmarkedCache
    private let source: Source.ID?
    private var cancelable: AnyCancellable?
    @Published private(set) var failureMessage: String?
    @Published private(set) var articles: [(article: Article, bookmarked: Bool)]?

    init(provider: any ArticleProvider, bookmarkedCache: BookmarkedCache, source: Source.ID? = nil) {
        self.provider = provider
        self.bookmarkedCache = bookmarkedCache
        self.source = source
    }

    func onAppear() {
        cancelable = bookmarkedCache.$articles.dropFirst().sink { [weak self] _ in
            self?.updateBookmarks()
        }
        Task {
            await onRefresh()
        }
    }

    func onRefresh() async {
        do {
            articles = try await provider.articles(category: nil, source: source).map {
                (article: $0, bookmarked: bookmarkedCache.isBookmarked(article: $0))
            }
        } catch {
            failureMessage = "\(error)"
        }
    }

    private func updateBookmarks() {
        self.articles = self.articles?.map { (article: $0.article, bookmarked: bookmarkedCache.isBookmarked(article: $0.article)) }
    }
}
