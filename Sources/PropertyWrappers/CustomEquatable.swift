//
//  CustomEquatable.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 12/1/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

@propertyWrapper
public struct CustomEquatable<WrappedValue>: Equatable {
    public var wrappedValue: WrappedValue
    
    @usableFromInline
    let equalsFunction: (WrappedValue, WrappedValue) -> Bool

    @inlinable
    public init(wrappedValue: WrappedValue, equals equalsFunction: @escaping (WrappedValue, WrappedValue) -> Bool) {
        self.wrappedValue = wrappedValue
        self.equalsFunction = equalsFunction
    }
    
    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.equalsFunction(lhs.wrappedValue, rhs.wrappedValue)
    }
}
