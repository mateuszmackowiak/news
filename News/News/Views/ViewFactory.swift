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
        TopHeadlinesView(viewModel: .init(provider: dependencyContainer.articleProvider()))
    }
}
