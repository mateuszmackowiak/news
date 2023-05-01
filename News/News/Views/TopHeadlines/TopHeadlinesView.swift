//
//  ContentView.swift
//  News
//
//  Created by Mateusz Mackowiak on 30/04/2023.
//

import SwiftUI

struct TopHeadlinesView: View {
    @ObservedObject private(set) var viewModel: ViewModel

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.articles ?? []) { article in
                    NavigationLink {
                        ArticleDetailsView(article: article)
                    } label: {
                        ArticleBasicInfoView(title: article.title, source: article.source)
                    }
                }
                .listRowBackground(Color.clear)
            }
            .accessibilityIdentifier("topHeadlines")
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
        .navigationBarItems(trailing: LogoView().frame(width: 22, height: 22))
    }
}

extension TopHeadlinesView {
    @MainActor
    final class ViewModel: ObservableObject {
        private var provider: any ArticleProvider
        @Published private(set) var failureMessage: String?
        @Published private(set) var articles: [Article]?

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
                articles = try await provider.articles()
            } catch {
                failureMessage = "\(error)"
            }
        }
    }
}


struct TopHeadlinesView_Previews: PreviewProvider {
    private struct ArticleProviderMock: ArticleProvider {
        func articles() async throws -> [Article] {
            [
                Article(id: "https://t3n.de/news/infografik-energieverbrauch-bitcoin-ethereum-vergleich-1548941/",
                     source: .init(id: "t3n", name: "T3n"),
                     author: "Kay Nordenbrock",
                     title: "Energieverbrauch von Bitcoin und Ethereum: Wie Wolkenkratzer neben Himbeere",
                     description: "Bitcoin verbraucht deutlich mehr Energie als Ethereum. Ethereum mit Proof-of-Stake wiederum benötigt deutlich",
                     url: URL(string: "https://t3n.de/news/infografik-energieverbrauch-bitcoin-ethereum-vergleich-1548941/")!,
                     urlToImage: URL(string: "https://t3n.de/news/wp-content/uploads/2023/04/Bitcoin-Ethereum-stromverbrauch-vergleich.jpg")!,
                     publishedAt: Date(timeIntervalSince1970: 1682773200),
                     content: "Die University of Cambridge zeigt in einer Analyse, wie viel Energie Ethereum vor und nach dem Wechsel von Proof-of-Work zu Proof-of-Stake verbraucht und wie diese Werte mit dem Verbrauch von Bitcoin… [+2366 chars]")
            ]
        }
    }
    static var previews: some View {
        NavigationView {
            TopHeadlinesView(viewModel: .init(provider: ArticleProviderMock()))
        }
            .preferredColorScheme(.dark)
    }
}
