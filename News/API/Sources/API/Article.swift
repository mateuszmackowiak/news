//
//  Created on 30/04/2023.
//
//

import Foundation

public struct Article: Decodable, Hashable, Sendable {
    public let source: ArticleSource
    public let author: String?
    public let title: String
    public let description: String?
    public let url: URL
    public let urlToImage: URL?
    public let publishedAt: Date
    public let content: String?
}
