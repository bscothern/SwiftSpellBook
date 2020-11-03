//
//  ManagedPointer.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 10/30/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

/// A property wrapper where the `WrappedValue` is stored in a pointer that is cleaned up when it goes out of scope.
///
/// The underlying pointer is deinitalized when the final copy of this struct goes out of scope.
@propertyWrapper
public struct ManagedPointer<WrappedValue> {
    @inlinable
    public var wrappedValue: WrappedValue {
        get { pointer.pointee }
        set { pointer.pointee = newValue }
        _modify { yield &pointer.pointee }
    }

    @inlinable
    public var projectedValue: Self { self }

    @OnDeinit(do: { pointer in
        pointer.deinitialize(count: 1)
        pointer.deallocate()
    })
    public var pointer: UnsafeMutablePointer<WrappedValue> = .allocate(capacity: 1)

    /// Creates a `@ManagedPointer`.
    ///
    /// - Parameter wrappedValue: The value used initialize the underlying pointer which has its `pointee` as the `WrappedValue`.
    @inlinable
    public init(wrappedValue: WrappedValue) {
        pointer.initialize(to: wrappedValue)
    }

    /// Creates a copy of a `@ManagedPointer` instance using a closure to copy the value.
    ///
    /// - Parameters:
    ///   - original: The original `@ManagedPointer` to create a copy of.
    ///   - valueCopyFunction: The function that creates a copy of `WrappedValue`.
    ///     If `WrappedValue` is a class type then it **must** create a new instance such that a `!==` will return `true` between `originalValuePointer.pointee` and the returned value.
    ///   - originalValuePointer: A pointer to the value contained in `original`.
    ///     This instance should not be mutated as a copy is created of it.
    @inlinable
    public init(copy original: Self, with valueCopyFunction: (_ originalValuePointer: UnsafePointer<WrappedValue>) -> WrappedValue) {
        let copy = valueCopyFunction(.init(original.pointer))
        let copyObject = copy as AnyObject
        let pointerObject = original.pointer.pointee as AnyObject
        precondition(copyObject !== pointerObject, "\(#function)'s valueCopyFunction did not return a different instance of WrappedValue (\(WrappedValue.self) which is required when creating a copy.")
        self = .init(wrappedValue: copy)
    }
}

extension ManagedPointer: PassThroughEquatablePropetyWrapper where WrappedValue: Equatable {}
extension ManagedPointer: PassThroughHashablePropetyWrapper where WrappedValue: Hashable {}
extension ManagedPointer: PassThroughComparablePropetyWrapper where WrappedValue: Comparable {}
extension ManagedPointer: PassThroughEncodablePropertyWrapper where WrappedValue: Encodable {}
extension ManagedPointer: PassThroughDecodablePropertyWrapper where WrappedValue: Decodable {}
