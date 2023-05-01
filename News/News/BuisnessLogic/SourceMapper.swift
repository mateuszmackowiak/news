//
//  SourceMapper.swift
//  News
//
//  Created by Mateusz Mackowiak on 01/05/2023.
//

import Foundation
import API

protocol SourceMapper {
    func map(_ sources: [API.Source]) -> [News.Source]
}

final class DefaultSourceMapper: SourceMapper {
    func map(_ sources: [API.Source]) -> [News.Source] {
        sources.map(map(_:))
    }

    private func map(_ source: API.Source) -> News.Source {
        .init(id: source.id,
              name: source.name,
              description: source.description,
              url: source.url,
              category: source.category,
              language: source.language,
              country: source.country)
    }
}
