//
//  SourcesView.swift
//  News
//
//  Created by Mateusz Mackowiak on 01/05/2023.
//

import SwiftUI

struct SourcesView<DestinationView: View>: View {
    @ObservedObject var viewModel: ViewModel
    @ViewBuilder let destinationView: @MainActor (_ source: Source) -> DestinationView

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.sources ?? []) { source in
                    NavigationLink(destination: { destinationView(source) }, label: {
                        SourceSummaryView(name: source.name,
                                          desc: source.description,
                                          category: source.category,
                                          language: source.language,
                                          country: source.country)
                    })
                }
                .listRowBackground(Color.clear)
            }
            .accessibilityIdentifier("sources")
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
                } else if let articles = viewModel.sources {
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
        .navigationTitle("Sources")
    }
}

struct SourcesView_Preview: PreviewProvider {
    private final class SourceProviderMock: SourceProvider {
        func source() async throws -> [Source] {
            [
                Source(
                    id: "abc-news",
                    name: "ABC News",
                    description: "Your trusted source for breaking news, analysis, exclusive interviews, headlines, and videos at ABCNews.com.",
                    url: URL(string: "https://abcnews.go.com")!,
                    category: "general",
                    language: "en",
                    country: "us"
                )
            ]
        }
    }

    static var previews: some View {
        SourcesView(viewModel: .init(provider: SourceProviderMock()), destinationView: { _ in EmptyView() })
    }
}
