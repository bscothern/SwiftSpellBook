//
//  PassThroughEncodablePropertyWrapper.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/2/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

/// A protocol that will have pass through encoding added to a property wrapper.
///
/// When used it will be as if the property wrapper doesn't exist when a value is encoded.
///
/// This type exists for convienece in conforming to both the requirements of the synthesis and `Encodable` all at once.
/// All requirements are defined on `_PassThroughEncodablePropertyWrapper`.
public typealias PassThroughEncodablePropertyWrapper = _PassThroughEncodablePropertyWrapper & Encodable

/// The protocol that backs `PassThroughEncodablePropertyWrapper` behavior.
///
/// You shouldn't normally conform to this protocol directly but use `PassThroughEncodablePropertyWrapper`.
public protocol _PassThroughEncodablePropertyWrapper {
    associatedtype WrappedValue: Encodable
    var wrappedValue: WrappedValue { get }
}

extension _PassThroughEncodablePropertyWrapper where Self: Encodable {
    @inlinable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}
