//
//  BookmarkedViewModel.swift
//  News
//
//  Created by Mateusz Mackowiak on 01/05/2023.
//

import Foundation

extension BookmarkedView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published private(set) var articles: [Article] = []

        init() {
        }

        func onAppear() {

        }

        func bookmarkAction(for article: Article) {

        }
    }
}
