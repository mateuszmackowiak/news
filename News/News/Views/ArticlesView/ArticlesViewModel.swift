//
//  TopHeadlinesViewModel.swift
//  News
//
//  Created by Mateusz Mackowiak on 01/05/2023.
//

import Foundation

@MainActor
final class ArticlesViewModel: ObservableObject {
    private var provider: any ArticleProvider
    let source: Source.ID?
    @Published private(set) var failureMessage: String?
    @Published private(set) var articles: [(article: Article, bookmarked: Bool)]?

    init(provider: any ArticleProvider, source: Source.ID? = nil) {
        self.provider = provider
        self.source = source
    }

    func onAppear() {
        Task {
            await onRefresh()
        }
    }

    func onRefresh() async {
        do {
            articles = try await provider.articles(category: nil, source: source).map {
                (article: $0, bookmarked: .random())
            }
        } catch {
            failureMessage = "\(error)"
        }
    }

    func bookmarkAction(for article: Article) {
        #warning("TODO: implement bookmarking")
    }
}
