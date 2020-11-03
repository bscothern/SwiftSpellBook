//
//  PassThroughEquatablePropetyWrapper.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/2/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

/// A protocol that will have pass through wrappedValue for equality.
///
/// This type exists for convienece in conforming to both the requirements of the synthesis and `Equatable` all at once.
/// All requirements are defined on `_PassThroughEquatablePropetyWrapper`.
public typealias PassThroughEquatablePropetyWrapper = _PassThroughEquatablePropetyWrapper & Equatable

/// The protocol that backs `PassThroughEquatablePropetyWrapper` behavior.
///
/// You shouldn't normally conform to this protocol directly but use `PassThroughEquatablePropetyWrapper`.
public protocol _PassThroughEquatablePropetyWrapper {
    associatedtype WrappedValue: Equatable
    var wrappedValue: WrappedValue { get }
}

extension _PassThroughEquatablePropetyWrapper where Self: Equatable {
    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}
