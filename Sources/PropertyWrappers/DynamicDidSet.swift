//
//  DynamicDidSet.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 12/1/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

@propertyWrapper
public struct DynamicDidSet<WrappedValue>: MutablePropertyWrapper {
    public var wrappedValue: WrappedValue {
        didSet {
            didSet?(wrappedValue, oldValue)
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

    public var didSet: ((_ value: WrappedValue, _ oldValue: WrappedValue) -> Void)?

    @inlinable
    public init(wrappedValue: WrappedValue, didSet: ((_ value: WrappedValue, _ oldValue: WrappedValue) -> Void)? = nil) {
        self.wrappedValue =  wrappedValue
        self.didSet = didSet
    }
}
