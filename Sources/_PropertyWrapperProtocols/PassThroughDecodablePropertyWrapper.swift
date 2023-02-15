//
//  PassThroughDecodablePropertyWrapper.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/2/20.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

/// A protocol that will have pass through decoding added to a property wrapper.
///
/// When used it will be as if the property wrapper doesn't exist when a value is decoded.
///
/// This type exists for convenience in conforming to both the requirements of the synthesis and `Decodable` all at once.
/// All requirements are defined on `_PassThroughDecodablePropertyWrapper`.
public typealias PassThroughDecodablePropertyWrapper = _PassThroughDecodablePropertyWrapper & DefaultInitializablePropertyWrapper & Decodable

/// The protocol that backs `PassThroughDecodablePropertyWrapper` behavior.
///
/// You shouldn't normally conform to this protocol directly but use `PassThroughDecodablePropertyWrapper`.
public protocol _PassThroughDecodablePropertyWrapper: DefaultInitializablePropertyWrapper where WrappedValue: Decodable {}

extension _PassThroughDecodablePropertyWrapper where Self: Decodable {
    @inlinable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(WrappedValue.self)
        self = .init(wrappedValue: value)
    }
}
