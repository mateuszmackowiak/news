//
//  Source.swift
//  News
//
//  Created by Mateusz Mackowiak on 01/05/2023.
//

import Foundation

struct Source: Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let description: String
    let url: URL
    let category: String
    let language: String
    let country: String
}
