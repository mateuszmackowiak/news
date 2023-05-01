//
//  DependencyContainer.swift
//  News
//
//  Created by Mateusz Mackowiak on 01/05/2023.
//

import Foundation
import API

final class DependencyContainer {
    private var userDefaultBookmarkStorage = UserDefaultBookmarkStorage(userDefaults: .standard)
    func bookmarkStorage() -> any BookmarkStorage {
        userDefaultBookmarkStorage
    }

    func articleProvider() -> any ArticleProvider {
        let overrideURL = baseURLOverride()?.appendingPathComponent("/v2/top-headlines")
        return APIArticleProvider(api: NetworkClientArticleApi(client: URLSessionClient(), url: overrideURL, apiToken: "f98efbe69f9c44e282001015ed055a08"), mapper: DefaultArticleMapper())
    }

    func sourceProvider() -> any SourceProvider {
        let overrideURL = baseURLOverride()?.appendingPathComponent("/v2/top-headlines/sources")
        return APISourceProvider(api: NetworkClientSourceAPI(client: URLSessionClient(), url: overrideURL, apiToken: "f98efbe69f9c44e282001015ed055a08"), mapper: DefaultSourceMapper())
    }

    private func baseURLOverride() -> URL? {
#if DEBUG
        // TO make the app ui tests stable I redirect the network to localhost and run a swift-nio server with networking stubs.
        // I use launchArguments to check if the redirect should be done
        if let port = UserDefaults.standard.object(forKey: "LaunchArgumentUseLocalServer") {
            return URL(string: "http://localhost:\(port)")!
        }
        return nil
#endif
    }
}
