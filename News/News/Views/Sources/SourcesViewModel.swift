//
//  SourcesViewModel.swift
//  News
//
//  Created by Mateusz Mackowiak on 01/05/2023.
//

import Foundation

extension SourcesView {
    @MainActor
    final class ViewModel: ObservableObject {
        private let provider: any SourceProvider
        @Published private(set) var sources: [Source]?
        @Published private(set) var failureMessage: String?

        init(provider: any SourceProvider) {
            self.provider = provider
        }

        func onAppear() {
            Task {
                await onRefresh()
            }
        }

        func onRefresh() async {
            do {
                sources = try await provider.source()
            } catch {
                failureMessage = "\(error)"
            }
        }
    }
}
