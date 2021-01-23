//
//  ManagedUnsafePointer.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 10/30/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

/// A property wrapper where a single `WrappedValue` is stored in a pointer that is cleaned up when it goes out of scope.
///
/// The underlying pointer is deinitialized when the final copy of this struct goes out of scope.
@propertyWrapper
public struct ManagedUnsafePointer<WrappedValue>: MutablePropertyWrapper, DefaultInitializablePropertyWrapper, ProjectedPropertyWrapper {
    @inlinable
    public var wrappedValue: WrappedValue {
        get { unsafeMutablePointer.pointee }
        set { unsafeMutablePointer.pointee = newValue }
        _modify {
            defer { _fixLifetime(self) }
            yield &unsafeMutablePointer.pointee
        }
    }

    @inlinable
    public var projectedValue: Self { self }

    @inlinable
    public var unsafePointer: UnsafePointer<WrappedValue> { .init(unsafeMutablePointer) }

    @OnDeinit(do: { pointer in
        pointer.deinitialize(count: 1)
        pointer.deallocate()
    })
    public internal(set) var unsafeMutablePointer: UnsafeMutablePointer<WrappedValue> = .allocate(capacity: 1)

    /// Creates a `@ManagedUnsafePointer` to a single element.
    ///
    /// - Parameter wrappedValue: The value used initialize the underlying pointer which has its `pointee` as the `WrappedValue`.
    public init(wrappedValue: WrappedValue) {
        unsafeMutablePointer.initialize(to: wrappedValue)
    }

    /// Creates a copy of a `@ManagedUnsafePointer` instance using a closure to copy the value.
    ///
    /// - Parameters:
    ///   - original: The original `@ManagedUnsafePointer` to create a copy of.
    ///   - valueCopyFunction: The function that creates a copy of `WrappedValue`.
    ///     If `WrappedValue` is a class type then it **must** create a new instance such that a `!==` will return `true` between `originalValuePointer.pointee` and the returned value.
    ///   - originalValuePointer: A pointer to the value contained in `original`.
    ///     This instance should not be mutated as a copy is created of it.
    @inlinable
    public init(copy original: Self, with valueCopyFunction: (_ originalValuePointer: UnsafePointer<WrappedValue>) -> WrappedValue) where WrappedValue: AnyObject {
        let copy = valueCopyFunction(original.unsafePointer)
        let copyObject = copy
        let pointerObject = original.wrappedValue
        precondition(copyObject !== pointerObject, "\(#function)'s valueCopyFunction did not return a different instance of WrappedValue (\(WrappedValue.self) which is required when creating a copy.")
        self = .init(wrappedValue: copy)
    }

    /// Creates a copy of a `@ManagedUnsafePointer` instance using a closure to copy the value.
    ///
    /// - Parameters:
    ///   - original: The original `@ManagedUnsafePointer` to create a copy of.
    ///   - valueCopyFunction: The function that creates a copy of `WrappedValue`.
    ///     If `WrappedValue` is a class type then it **must** create a new instance such that a `!==` will return `true` between `originalValuePointer.pointee` and the returned value.
    ///   - originalValuePointer: A pointer to the value contained in `original`.
    ///     This instance should not be mutated as a copy is created of it.
    @inlinable
    @_disfavoredOverload
    public init(copy original: Self, with valueCopyFunction: (_ originalValuePointer: UnsafePointer<WrappedValue>) -> WrappedValue) {
        let copy = valueCopyFunction(original.unsafePointer)
//        let copyObject = copy as AnyObject
//        let pointerObject = original.wrappedValue as AnyObject
//        precondition(copyObject !== pointerObject, "\(#function)'s valueCopyFunction did not return a different instance of WrappedValue (\(WrappedValue.self) which is required when creating a copy.")
        self = .init(wrappedValue: copy)
    }

    /// Creates a copy of the `@ManagedUnsafePointer`
    ///
    /// - Parameters:
    ///   - valueCopyFunction: The function that creates a copy of `WrappedValue`.
    ///     If `WrappedValue` is a class type then it **must** create a new instance such that a `!==` will return `true` between `originalValuePointer.pointee` and the returned value.
    ///   - originalValuePointer: A pointer to the value contained in `original`.
    ///     This instance should not be mutated as a copy is created of it.
    /// - Returns: A new `@ManagedUnsafePointer` that is a copy of this instance.
    @inlinable
    public func copy(_ valueCopyFunction: (_ originalValuePointer: UnsafePointer<WrappedValue>) -> WrappedValue) -> Self where WrappedValue: AnyObject {
        .init(copy: self, with: valueCopyFunction)
    }

    /// Creates a copy of the `@ManagedUnsafePointer`
    ///
    /// - Parameters:
    ///   - valueCopyFunction: The function that creates a copy of `WrappedValue`.
    ///     If `WrappedValue` is a class type then it **must** create a new instance such that a `!==` will return `true` between `originalValuePointer.pointee` and the returned value.
    ///   - originalValuePointer: A pointer to the value contained in `original`.
    ///     This instance should not be mutated as a copy is created of it.
    /// - Returns: A new `@ManagedUnsafePointer` that is a copy of this instance.
    @inlinable
    @_disfavoredOverload
    public func copy(_ valueCopyFunction: (_ originalValuePointer: UnsafePointer<WrappedValue>) -> WrappedValue) -> Self {
        .init(copy: self, with: valueCopyFunction)
    }
}

extension ManagedUnsafePointer: PassThroughEquatablePropertyWrapper where WrappedValue: Equatable {}
extension ManagedUnsafePointer: PassThroughHashablePropertyWrapper where WrappedValue: Hashable {}
extension ManagedUnsafePointer: PassThroughComparablePropertyWrapper where WrappedValue: Comparable {}
extension ManagedUnsafePointer: PassThroughEncodablePropertyWrapper where WrappedValue: Encodable {}
extension ManagedUnsafePointer: PassThroughDecodablePropertyWrapper where WrappedValue: Decodable {}
