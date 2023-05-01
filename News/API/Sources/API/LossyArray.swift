//
//  File.swift
//  
//

import Foundation

@propertyWrapper
public struct LossyArray<T: Decodable & Sendable>: Decodable, ExpressibleByArrayLiteral, Sendable {
    public typealias ArrayLiteralElement = T

    private struct LossyDecodableValue<Value: Decodable>: Decodable {
        let value: Value

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            value = try container.decode(Value.self)
        }
    }

    public var wrappedValue: [T]

    public init(wrappedValue: [T]) {
        self.wrappedValue = wrappedValue
    }

    public init(arrayLiteral elements: T...) {
        self.init(wrappedValue: elements)
    }

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var elements: [T] = []
        var countOfFailedElements = 0
        var firstDecodingError: Error?
        while !container.isAtEnd {
            if let count = container.count, countOfFailedElements + elements.count >= count {
                break
            }
            do {
                elements.append(try container.decode(LossyDecodableValue<T>.self).value)
            } catch {
                firstDecodingError = error
                print("Skipping invalid structure \(error)")
                countOfFailedElements += 1
            }
        }
        if elements.count == 0 && countOfFailedElements > 0, let firstDecodingError = firstDecodingError {
            throw firstDecodingError
        }
        self.wrappedValue = elements
    }
}

extension LossyArray: Encodable where T: Encodable {
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}
extension LossyArray: Equatable where T: Equatable { }
extension LossyArray: Hashable where T: Hashable { }
