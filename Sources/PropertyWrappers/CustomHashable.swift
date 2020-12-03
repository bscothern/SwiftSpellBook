//
//  CustomHashable.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 12/1/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

@propertyWrapper
public struct CustomHashable<WrappedValue>: Hashable {
    public var wrappedValue: WrappedValue
    
    @usableFromInline
    let equalsFunction: (WrappedValue, WrappedValue) -> Bool
    
    @usableFromInline
    let hashFunction: (_ hasher: inout Hasher, _ value: WrappedValue) -> Void
    
    @inlinable
    public init(wrappedValue: WrappedValue, equals equalsFunction: @escaping (WrappedValue, WrappedValue) -> Bool, hash hashFunction: @escaping (_ hasher: inout Hasher, _ value: WrappedValue) -> Void) {
        self.wrappedValue = wrappedValue
        self.equalsFunction = equalsFunction
        self.hashFunction = hashFunction
    }
    
    @inlinable
    public init(wrappedValue: WrappedValue, hash hashFunction: @escaping (_ hasher: inout Hasher, _ value: WrappedValue) -> Void) where WrappedValue: Equatable {
        self.init(wrappedValue: wrappedValue, equals: ==, hash: hashFunction)
    }
    
    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.equalsFunction(lhs.wrappedValue, rhs.wrappedValue)
    }
    
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hashFunction(&hasher, wrappedValue)
    }
}
