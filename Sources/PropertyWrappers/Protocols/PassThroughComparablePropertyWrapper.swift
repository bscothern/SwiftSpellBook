//
//  PassThroughComparablePropetyWrapper.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/2/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

/// A protocol that will have pass through wrappedValue for comparison.
///
/// This type exists for convienece in conforming to both the requirements of the synthesis and `Comparable` all at once.
/// All requirements are defined on `_PassThroughComparablePropetyWrapper`.
public typealias PassThroughComparablePropetyWrapper = _PassThroughComparablePropetyWrapper & Comparable

/// The protocol that backs `PassThroughComparablePropetyWrapper` behavior.
///
/// You shouldn't normally conform to this protocol directly but use `PassThroughComparablePropetyWrapper`.
public protocol _PassThroughComparablePropetyWrapper {
    associatedtype WrappedValue: Comparable
    var wrappedValue: WrappedValue { get }
}

extension _PassThroughComparablePropetyWrapper where Self: Comparable {
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.wrappedValue < rhs.wrappedValue
    }
}
