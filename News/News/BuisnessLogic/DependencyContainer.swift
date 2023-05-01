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
        return APIArticleProvider(api: NetworkClientArticleApi(client: URLSessionClient(), apiToken: "f98efbe69f9c44e282001015ed055a08"), mapper: DefaultArticleMapper())
    }
}
