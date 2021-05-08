//
//  Comparable.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 4/9/21.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

extension Comparable {
    @inlinable
    public mutating func clamp(to range: ClosedRange<Self>) {
        if self < range.lowerBound {
            self = range.lowerBound
        } else if self > range.upperBound {
            self = range.upperBound
        }
    }

    @inlinable
    public func clamped(to range: ClosedRange<Self>) -> Self {
        var copy = self
        copy.clamp(to: range)
        return copy
    }
}
