//
//  SourceProvider.swift
//  News
//
//  Created by Mateusz Mackowiak on 01/05/2023.
//

import Foundation
import API

protocol SourceProvider {
    func source() async throws -> [Source]
}

final class APISourceProvider: SourceProvider {
    private let api: any SourceAPI
    private let mapper: any SourceMapper
    private let locale: Locale

    init(api: any SourceAPI, mapper: any SourceMapper, locale: Locale = .current) {
        self.api = api
        self.mapper = mapper
        self.locale = locale
    }

    func source() async throws -> [Source] {
        do {
            let sources = mapper.map(try await api.getSources(country: nil, category: nil))
            Log.debug("Received articles \(sources)")
            return sources
        } catch {
            Log.warning("Failed to fetch articles \(error)")
            throw error
        }
    }
}
