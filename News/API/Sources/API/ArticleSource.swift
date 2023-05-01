//
//  Created on 30/04/2023.
//
//

import Foundation

public struct ArticleSource: Decodable, Hashable, Sendable {
    public typealias ID = String

    public let id: ID?
    public let name: String
}

