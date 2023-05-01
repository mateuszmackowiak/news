//
//  TabView.swift
//  News
//
//  Created by Mateusz Mackowiak on 01/05/2023.
//

import SwiftUI


struct BookmarkedView<DestinationView: View>: View {
    @ObservedObject private(set) var viewModel: BookmarkedViewModel
    @ViewBuilder let destinationView: @MainActor (_ article: Article) -> DestinationView

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.articles) { article in
                    NavigationLink(destination: { destinationView(article) }) {
                        ArticleSummaryView(title: article.title,
                                           imageURL: article.urlToImage,
                                           desc: article.description,
                                           bookmarked: true,
                                           publishedDate: article.publishedAt,
                                           source: article.source.name)
                    }
                }
                .listRowBackground(Color.clear)
            }
            .accessibilityIdentifier("bookmark")
            .listStyle(.plain)
            .overlay {
                if viewModel.articles.isEmpty {
                    VStack(spacing: 10) {
                        Image(systemName: "bookmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30)
                            .foregroundColor(.accentColor)
                        Text("Loos like You have not bookmarks")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                    }
                }
            }
        }
        .background(Color.background)
        .foregroundColor(Color.primaryText)
        .navigationTitle("Bookmarks")
    }
}

struct BookmarkedView_Previews: PreviewProvider {
    private final class BookmarkStorageMock: BookmarkStorage {
        func store(articles: [Article]) {}
        func articles() -> [Article] { [] }
    }
    static var previews: some View {
        TabView {
            NavigationView {
                BookmarkedView(viewModel: .init(bookmarkedCache: BookmarkedCache(bookmarkStorage: BookmarkStorageMock())), destinationView: { _ in EmptyView() })
            }
        }
        .preferredColorScheme(.dark)
    }
}
