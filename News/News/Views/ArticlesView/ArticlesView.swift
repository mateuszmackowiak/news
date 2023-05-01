//
//  ContentView.swift
//  News
//
//  Created by Mateusz Mackowiak on 30/04/2023.
//

import SwiftUI

struct ArticlesView<DestinationView: View>: View {
    @ObservedObject private(set) var viewModel: ArticlesViewModel
    @ViewBuilder let destinationView: @MainActor (_ article: Article) -> DestinationView

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.articles ?? [], id: \.0) { (article, bookmarked) in
                    NavigationLink(destination: { destinationView(article) }) {
                        ArticleSummaryView(title: article.title,
                                           imageURL: article.urlToImage,
                                           desc: article.description,
                                           bookmarked: bookmarked,
                                           publishedDate: article.publishedAt,
                                           source: article.source.name)
                    }
                }
                .listRowBackground(Color.clear)
            }
            .accessibilityIdentifier("articles")
            .listStyle(.plain)
            .overlay {
                if let failureMessage = viewModel.failureMessage {
                    ZStack {
                        Color.background.ignoresSafeArea()
                        Text(failureMessage)
                            .minimumScaleFactor(0.5)
                        Button {
                            Task {
                                await viewModel.onRefresh()
                            }
                        } label: {
                            Text("Retry")
                        }
                        .buttonStyle(.bordered)
                    }
                } else if let articles = viewModel.articles {
                    if articles.isEmpty {
                        ZStack {
                            Color.background.ignoresSafeArea()
                            Text("Oops, loos like there's no data...")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                        }
                    }
                } else {
                    ZStack {
                        Color.background.ignoresSafeArea()
                        ActivityIndicatorView()
                            .frame(width: 48)
                    }
                }
            }
        }
        .onAppear { viewModel.onAppear() }
        .refreshable { await viewModel.onRefresh() }
        .background(Color.background)
        .foregroundColor(Color.primaryText)
        .navigationTitle("Article")
    }
}

struct ArticlesView_Previews: PreviewProvider {
    private struct ArticleProviderMock: ArticleProvider {
        func articles(category: Category?, source: Source.ID?) async throws -> [Article] {
            [
                Article(id: "https://t3n.de/news/infografik-energieverbrauch-bitcoin-ethereum-vergleich-1548941/",
                     source: .init(id: "t3n", name: "T3n"),
                     author: "Kay Nordenbrock",
                     title: "Energieverbrauch von Bitcoin und Ethereum: Wie Wolkenkratzer neben Himbeere",
                     description: "Bitcoin verbraucht deutlich mehr Energie als Ethereum. Ethereum mit Proof-of-Stake wiederum benötigt deutlich",
                     url: URL(string: "https://t3n.de/news/infografik-energieverbrauch-bitcoin-ethereum-vergleich-1548941/")!,
                     urlToImage: URL(string: "https://t3n.de/news/wp-content/uploads/2023/04/Bitcoin-Ethereum-stromverbrauch-vergleich.jpg")!,
                     publishedAt: Date(timeIntervalSince1970: 1682773200),
                     content: "Die University of Cambridge zeigt in einer Analyse, wie viel Energie Ethereum vor und nach dem Wechsel von Proof-of-Work zu Proof-of-Stake verbraucht und wie diese Werte mit dem Verbrauch von Bitcoin… [+2366 chars]"),

                Article(id: "https://9to5mac.com/2023/04/29/malware-virus-scanner-for-mac/",
                        source: .init(id: nil, name: "9to5Mac"),
                        author: "Michael Potuck",
                        title: "Virus scanner for Mac – How to remove malware - 9to5Mac",
                        description: "This guide covers malware and virus scanner for Mac tools from free to paid to help you find and remove malicious software.",
                        url: URL(string: "https://9to5mac.com/2023/04/29/malware-virus-scanner-for-mac/")!,
                        urlToImage: URL(string: "https://i0.wp.com/9to5mac.com/wp-content/uploads/sites/6/2023/04/malware-virus-scanner-for-mac.jpeg?resize=1200%2C628&quality=82&strip=all&ssl=1")!,
                        publishedAt: Date(timeIntervalSince1970: 1682373200),
                        content: "Macs are more protected from malicious software like viruses, Trojans, adware, etc. than Windows and Linux. However, they aren’t immune, and more and more malware is being designed specifically for M… [+3682 chars]")
            ]
        }
    }

    private final class BookmarkStorageMock: BookmarkStorage {
        func store(articles: [Article]) { }
        func articles() -> [Article] { [] }
    }

    static var previews: some View {
        NavigationView {
            ArticlesView(viewModel: .init(provider: ArticleProviderMock(), bookmarkedCache: BookmarkedCache(bookmarkStorage: BookmarkStorageMock())), destinationView: { _ in EmptyView() })
        }
        .preferredColorScheme(.dark)
    }
}
