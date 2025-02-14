//
//  PassThroughHashablePropertyWrapper.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/2/20.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

/// A protocol that will have pass through wrappedValue for equality.
///
/// This type exists for convenience in conforming to both the requirements of the synthesis and `Hashable` all at once.
/// All requirements are defined on `_PassThroughHashablePropertyWrapper`.
public typealias PassThroughHashablePropertyWrapper = _PassThroughHashablePropertyWrapper & PropertyWrapper & Hashable

/// The protocol that backs `PassThroughHashablePropetyWrapper` behavior.
///
/// You shouldn't normally conform to this protocol directly but use `PassThroughHashablePropetyWrapper`.
public protocol _PassThroughHashablePropertyWrapper: PropertyWrapper where WrappedValue: Hashable {}

extension _PassThroughHashablePropertyWrapper where Self: Hashable {
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedValue)
    }
}
