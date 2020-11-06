//
//  OnDeinit.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 10/30/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

/// A property wrapper that ties a deinit function to the lifetime of its `WrappedValue`.
///
/// This is extra helpful when you want to use a pointer in a struct type.
///
/// - Important: This is backed by a class in order to trigger the `DeinitAction`.
///     This means that if you pass an instance around you will be pointing to the same backing instance.
///     This is adventagous because this type is generally most helpful when managing memory.
///     If you need to ensure a copy is unique you can call `makeUnique()` or if you want to create a copy you can use `copy()`.
///     See those functions for more information.
///     You can also use `@OnDeinitCOW` if you want copy on write behavior.
@propertyWrapper
public struct OnDeinit<WrappedValue> {
    /// The function that is called when this property wrapper goes out of scope.
    ///
    /// - Parameter wrappedValue: The final value contained in `wrappedValue` when `deinit` is triggered.
    public typealias DeinitAction = (_ wrappedValue: WrappedValue) -> Void

    /// The box type that enables `OnDeinit` to trigger its deinit action.
    ///
    /// It acts as the storage for all of the instance.
    @usableFromInline
    final class Box {
        @usableFromInline
        var wrappedValue: WrappedValue

        @usableFromInline
        var deinitAction: DeinitAction

        @usableFromInline
        init(wrappedValue: WrappedValue, do deinitAction: @escaping DeinitAction) {
            self.wrappedValue = wrappedValue
            self.deinitAction = deinitAction
        }

        @usableFromInline
        deinit {
            deinitAction(wrappedValue)
        }
    }

    @inlinable
    @_transparent
    public var wrappedValue: WrappedValue {
        get { box.wrappedValue }
        set { box.wrappedValue = newValue }
        _modify { yield &box.wrappedValue }
    }

    @usableFromInline
    var box: Box

    /// Creates an `@OnDeinit`.
    ///
    /// - Parameters:
    ///   - wrappedValue: The initial value of the `wrappedValue` property.
    ///   - deinitAction: The function that should be called when this property wrapper goes out of scope.
    @inlinable
    @_transparent
    public init(wrappedValue: WrappedValue, do deinitAction: @escaping DeinitAction) {
        self.box = .init(wrappedValue: wrappedValue, do: deinitAction)
    }

    /// Creates a copy of the `OnDeinit` that has the current `wrappedValue` and the `DeinitAction` the original instance was created with.
    @inlinable
    public func copy() -> Self {
        .init(wrappedValue: box.wrappedValue, do: box.deinitAction)
    }

    /// If the backing memory is referenced by another instance than this instance then it copies its `wrappedValue` and `DeinitAction` into new backing storage.
    @inlinable
    public mutating func makeUnique() {
        guard !isKnownUniquelyReferenced(&box) else { return }
        self = copy()
    }
}

extension OnDeinit: PassThroughEquatablePropetyWrapper where WrappedValue: Equatable {}
extension OnDeinit: PassThroughHashablePropetyWrapper where WrappedValue: Hashable {}
extension OnDeinit: PassThroughComparablePropetyWrapper where WrappedValue: Comparable {}

// This is all experimental stuff to learn more about how to work with ManagedBuffer and SafeManagedBuffer
// It does not currently work as all accessed to wrappedValue crash...
#if false

import SwiftMemoryManagementSpellBook

@propertyWrapper
public final class OnDeinit_Buffered<WrappedValue>: SafeManagedBuffer<(WrappedValue) -> Void, WrappedValue>, _OnDeinit {
    @inlinable
    public var wrappedValue: WrappedValue {
        get {
            withUnsafeMutablePointerToElements { element in
                element.pointee
            }
        }
        set { withUnsafeMutablePointerToElements { $0.pointee = newValue } }
        _modify {
            var wrappedValue: WrappedValue!
            withUnsafeMutablePointerToElements { wrappedValue = $0.move() }
            defer { withUnsafeMutablePointerToElements { $0.initialize(to: wrappedValue) } }
            yield &wrappedValue
        }
    }

    @inlinable
    deinit {
        withUnsafeMutablePointers { header, element in
            header.pointee.value(element.pointee)
        }
    }
}

// TODO: This seems to be the is the only way to add inits to types that inherit from SafeManagedBuffer so it needs to be documented.
public protocol _OnDeinit: SafeManagedBufferProtocol where HeaderValue == (WrappedValue) -> Void, WrappedValue == Element {
    associatedtype WrappedValue
}

extension _OnDeinit {
    public init(wrappedValue: WrappedValue, do deinitFunction: @escaping (_ wrappedValue: WrappedValue) -> Void) {
        self.init(
            minimumCapacity: 1,
            deinitStrategy: .minimumCapacity,
            makingHeaderWith: { _ in deinitFunction },
            thenFinishInit: {
                $0.withUnsafeMutablePointerToElements { element in
                    element.initialize(to: wrappedValue)
                }
            }
        )
    }
}

extension OnDeinit_Buffered: PassThroughEquatablePropetyWrapper where WrappedValue: Equatable {}
extension OnDeinit_Buffered: PassThroughHashablePropetyWrapper where WrappedValue: Hashable {}
extension OnDeinit_Buffered: PassThroughComparablePropetyWrapper where WrappedValue: Comparable {}
#endif
