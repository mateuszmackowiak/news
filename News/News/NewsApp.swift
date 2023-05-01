//
//  NewsApp.swift
//  News
//
//  Created by Mateusz Mackowiak on 30/04/2023.
//

import SwiftUI

@main
@MainActor
struct NewsApp: App {
    private let viewFactory = ViewFactory(dependencyContainer: DependencyContainer())

    var body: some Scene {
        WindowGroup {
            NavigationView {
                viewFactory.topHeadlinesView()
            }
            .preferredColorScheme(.dark)
        }
    }
}
