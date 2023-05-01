//
//  TopHeadlinesViewModel.swift
//  News
//
//  Created by Mateusz Mackowiak on 01/05/2023.
//

import Foundation

extension TopHeadlinesView {
    @MainActor
    final class ViewModel: ObservableObject {
        private var provider: any ArticleProvider
        @Published private(set) var failureMessage: String?
        @Published private(set) var articles: [(Article, bookmarked: Bool)]?

        init(provider: any ArticleProvider) {
            self.provider = provider
        }

        func onAppear() {
            Task {
                await onRefresh()
            }
        }

        func onRefresh() async {
            do {
                articles = try await provider.articles().map {
                    ($0, bookmarked: .random())
                }
            } catch {
                failureMessage = "\(error)"
            }
        }

        func bookmarkAction(for article: Article) {

        }
    }
}
