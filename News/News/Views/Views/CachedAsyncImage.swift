//
//  CachedAsyncImage.swift
//  News
//
//  Created by Mateusz Mackowiak on 01/05/2023.
//

import SwiftUI

struct CachedAsyncImage<Content>: View where Content: View{
    private let url: URL
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content
    private let cache: ImageCache

    init(url: URL,
         scale: CGFloat = UIScreen.main.scale,
         transaction: Transaction = Transaction(),
         cache: ImageCache = .shared,
         @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.cache = cache
        self.content = content
    }

    var body: some View{
        if let cached = cache[url] {
            content(.success(cached))
        } else {
            AsyncImage(url: url,
                       scale: scale,
                       transaction: transaction,
                       content: cacheAndRender(phase:))
        }
    }

    private func cacheAndRender(phase: AsyncImagePhase) -> some View {
        if case .success (let image) = phase {
            cache[url] = image
        }
        return content(phase)
    }
}

final class ImageCache {
    static let shared = ImageCache()
    private var cache: [URL: Image] = [:]
    subscript(url: URL) -> Image?{
        get {
            cache[url]
        }
        set {
            cache[url] = newValue
        }
    }
}
