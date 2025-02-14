//
//  PassThroughComparablePropertyWrapper.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/2/20.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

/// A protocol that will have pass through wrappedValue for comparison.
///
/// This type exists for convenience in conforming to both the requirements of the synthesis and `Comparable` all at once.
/// All requirements are defined on `_PassThroughComparablePropertyWrapper`.
public typealias PassThroughComparablePropertyWrapper = _PassThroughComparablePropertyWrapper & PropertyWrapper & Comparable

/// The protocol that backs `PassThroughComparablePropertyWrapper` behavior.
///
/// You shouldn't normally conform to this protocol directly but use `PassThroughComparablePropertyWrapper`.
public protocol _PassThroughComparablePropertyWrapper: PropertyWrapper where WrappedValue: Comparable {}

extension _PassThroughComparablePropertyWrapper where Self: Comparable {
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.wrappedValue < rhs.wrappedValue
    }
}
