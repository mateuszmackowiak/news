//
//  ViewFactory.swift
//  News
//
//  Created by Mateusz Mackowiak on 01/05/2023.
//

import SwiftUI

@MainActor
final class ViewFactory {
    let dependencyContainer: DependencyContainer

    init(dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
    }

    func topHeadlinesView() -> some View {
        NavigationView {
            TopHeadlinesView(viewModel: .init(provider: dependencyContainer.articleProvider()))
        }
    }

    func bookmarkedView() -> some View {
        NavigationView {
            BookmarkedView(viewModel: .init())
        }
    }

    func mainView() -> some View {
        TabView {
            topHeadlinesView()
                .tabItem {
                    Image.headlinesTabItem
                }

            bookmarkedView()
                .tabItem {
                    Image(systemName: "bookmark")
                }
        }
    }
}
