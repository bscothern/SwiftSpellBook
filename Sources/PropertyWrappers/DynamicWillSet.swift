//
//  DynamicOnSet.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 12/1/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

@propertyWrapper
public struct DynamicWillSet<WrappedValue>: MutablePropertyWrapper {
    public var wrappedValue: WrappedValue {
        willSet {
            willSet?(wrappedValue, newValue)
        }
    }

    @inlinable
    public var projectedValue: Self {
        get { self }
        set { self = newValue }
        _modify {
            defer { _fixLifetime(self) }
            yield &self
        }
    }

    public var willSet: ((_ value: WrappedValue, _ newValue: WrappedValue) -> Void)?

    @inlinable
    public init(wrappedValue: WrappedValue, willSet: ((_ value: WrappedValue, _ newValue: WrappedValue) -> Void)? = nil) {
        self.wrappedValue = wrappedValue
        self.willSet = willSet
    }
}
