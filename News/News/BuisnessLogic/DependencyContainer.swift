//
//  DependencyContainer.swift
//  News
//
//  Created by Mateusz Mackowiak on 01/05/2023.
//

import Foundation
import API

final class DependencyContainer {
    func articleProvider() -> any ArticleProvider {
        var articlesOverrideURL: URL? = nil
#if DEBUG
        // TO make the app ui tests stable I redirect the network to localhost and run a swift-nio server with networking stubs.
        // I use launchArguments to check if the redirect should be done
        if let port = UserDefaults.standard.object(forKey: "LaunchArgumentUseLocalServer") {
            let baseURL = URL(string: "http://localhost:\(port)")!
            articlesOverrideURL = baseURL.appendingPathComponent("/v2/top-headlines")
        }
#endif
        return APIArticleProvider(api: NetworkClientArticleApi(client: URLSessionClient(), url: articlesOverrideURL, apiToken: "f98efbe69f9c44e282001015ed055a08"), mapper: DefaultArticleMapper())
    }
}
