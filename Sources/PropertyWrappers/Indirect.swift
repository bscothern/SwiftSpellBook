//
//  Indirect.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 10/30/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

@propertyWrapper
public struct Indirect<WrappedValue> {
    @usableFromInline
    indirect enum _Indirect {
        case value(WrappedValue, Self? = nil)
    }

    @usableFromInline
    var value: _Indirect
    
    @inlinable
    public var wrappedValue: WrappedValue {
        switch value {
        case let .value(value, _):
            return value
        }
    }
    
    @inlinable
    public init(wrappedValue: WrappedValue) {
        self.value = .value(wrappedValue)
    }
}

extension Indirect: Equatable where WrappedValue: Equatable {}
extension Indirect._Indirect: Equatable where WrappedValue: Equatable {}
extension Indirect: Hashable where WrappedValue: Hashable {}
extension Indirect._Indirect: Hashable where WrappedValue: Hashable {}

extension Indirect where WrappedValue: Encodable {
    @inlinable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}

extension Indirect where WrappedValue: Decodable {
    @inlinable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(WrappedValue.self)
        self = .init(wrappedValue: value)
    }
}
