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

    func sourcesView() -> some View {
        NavigationView {
            SourcesView(viewModel: .init(provider: dependencyContainer.sourceProvider()))
        }
    }

    func mainView() -> some View {
        TabView {
            bookmarkedView()
                .tabItem {
                    Image(systemName: "bookmark")
                        .accessibilityIdentifier("bookmark")
                }

            topHeadlinesView()
                .tabItem {
                    Image.headlinesTabItem
                        .accessibilityIdentifier("headlines")
                }

            sourcesView()
                .tabItem {
                    Image(systemName: "dot.radiowaves.left.and.right")
                        .accessibilityIdentifier("sources")
                }
        }
    }
}
