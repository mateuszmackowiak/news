//
//  TabView.swift
//  News
//
//  Created by Mateusz Mackowiak on 01/05/2023.
//

import SwiftUI

struct BookmarkedView: View {
    @ObservedObject private(set) var viewModel: ViewModel

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.articles) { article in
                    NavigationLink {
                        ArticleDetailsView(article: article)
                    } label: {
                        ArticleSummaryView(title: article.title,
                                           imageURL: article.urlToImage,
                                           desc: article.description,
                                           bookmarked: true,
                                           publishedDate: article.publishedAt,
                                           source: article.source.name,
                                           bookmarkAction: {
                            viewModel.bookmarkAction(for: article)
                        })
                    }
                }
                .listRowBackground(Color.clear)
            }
            .accessibilityIdentifier("topHeadlines")
            .listStyle(.plain)
            .overlay {
                if viewModel.articles.isEmpty {
                    VStack(spacing: 10) {
                        Image(systemName: "bookmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 44)
                            .foregroundColor(.secondaryAccentColor)
                        Text("Loos like You have not bookmarks")
                            .font(.title)
                            .multilineTextAlignment(.center)
                    }
                }
            }
        }
        .onAppear { viewModel.onAppear() }
        .background(Color.background)
        .foregroundColor(Color.primaryText)
        .navigationTitle("Bookmarks")
        .navigationBarItems(trailing: LogoView().frame(width: 22, height: 22))
    }
}

struct BookmarkedView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            NavigationView {
                BookmarkedView(viewModel: .init())
            }
        }
        .preferredColorScheme(.dark)
    }
}
