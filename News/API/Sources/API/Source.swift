//
//  File.swift
//  
//
//  Created by Mateusz Mackowiak on 01/05/2023.
//

import Foundation

public struct Source: Identifiable, Decodable, Hashable, Sendable {
    public let id: String
    public let name: String
    public let description: String
    public let url: URL
    public let category: String
    public let language: String
    public let country: String
}
