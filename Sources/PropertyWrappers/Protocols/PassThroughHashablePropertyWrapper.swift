//
//  PassThroughHashablePropetyWrapper.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/2/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

/// A protocol that will have pass through wrappedValue for equality.
///
/// This type exists for convienece in conforming to both the requirements of the synthesis and `Hashable` all at once.
/// All requirements are defined on `_PassThroughHashablePropetyWrapper`.
public typealias PassThroughHashablePropetyWrapper = _PassThroughHashablePropetyWrapper & Hashable

/// The protocol that backs `PassThroughHashablePropetyWrapper` behavior.
///
/// You shouldn't normally conform to this protocol directly but use `PassThroughHashablePropetyWrapper`.
public protocol _PassThroughHashablePropetyWrapper {
    associatedtype WrappedValue: Hashable
    var wrappedValue: WrappedValue { get }
}

extension _PassThroughHashablePropetyWrapper where Self: Hashable {
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedValue)
    }
}
