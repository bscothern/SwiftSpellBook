//
//  Comparable.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 4/9/21.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

extension Comparable {
    /// Clamps a value to be within a a range.
    ///
    /// - Parameter range: The `ClosedRange` to ensure that `self` is contained in.
    @inlinable
    public mutating func clamp(to range: ClosedRange<Self>) {
        if self < range.lowerBound {
            self = range.lowerBound
        } else if self > range.upperBound {
            self = range.upperBound
        }
    }

    /// Creates a clamped copy of `Self` such that it is in the provided range.
    ///
    /// - Parameter range: The `ClosedRange` to ensure that the result is contained in.
    /// - Returns: `self` if it is already within in `range`, otherwise it is the `lowerBound` of the range if less than that and the `upperBound` if greater than that.
    @inlinable
    public func clamped(to range: ClosedRange<Self>) -> Self {
        var copy = self
        copy.clamp(to: range)
        return copy
    }
}
