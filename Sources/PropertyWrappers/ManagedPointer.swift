//
//  ManagedPointer.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 10/30/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

@propertyWrapper
public struct ManagedPointer<WrappedValue> {
    @inlinable
    public var wrappedValue: WrappedValue {
        get { _wrappedValue.pointee }
        set { _wrappedValue.pointee = newValue }
        _modify { yield &_wrappedValue.pointee }
    }

    @inlinable
    public var projectedValue: UnsafeMutablePointer<WrappedValue> {
        get { _wrappedValue }
        set { _wrappedValue = newValue }
        _modify { yield &_wrappedValue }
    }

    @usableFromInline
    @OnDeinit(do: { pointer in
        pointer.deinitialize(count: 1)
        pointer.deallocate()
    })
    var _wrappedValue: UnsafeMutablePointer<WrappedValue> = .allocate(capacity: 1)
    
    @inlinable
    public init(wrappedValue: WrappedValue) {
        _wrappedValue.initialize(to: wrappedValue)
    }
}

@propertyWrapper
public final class ManagedPointer2<WrappedValue>: ManagedBuffer<Void, WrappedValue> {
    public var wrappedValue: WrappedValue {
        fatalError()
    }
}
