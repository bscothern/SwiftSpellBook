//
//  OnDeinit.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 10/30/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

import SwiftBoxesSpellBook

/// A property wrapper that ties a deinit function to the lifetime of its `WrappedValue`.
///
/// This is extra helpful when you want to use a pointer in a struct type.
///
/// - Important: This is backed by a class in order to trigger the `DeinitAction`.
///     This means that if you pass an instance around you will be pointing to the same backing instance.
///     This is advantageous because this type is generally most helpful when managing memory.
///
/// - Important: This does not have copy-on-write (COW) behavior but has reference semantics.
///     This is because it is designed to help with memory managemet and COW behavior will cause memory corruption or crashes in most cases with this type.
///     If you want this behavior and know it to be correct use the `@OnDeinitCOW` property wrapper instead.
///     For more information see the `unsafeCopy()` and `unsafeMakeUnique()` functions of this type.
@propertyWrapper
public struct OnDeinit<WrappedValue>: MutablePropertyWrapper {
    /// The function that is called when this property wrapper goes out of scope.
    ///
    /// - Parameter wrappedValue: The final value contained in `wrappedValue` when `deinit` is triggered.
    public typealias DeinitAction = (_ wrappedValue: WrappedValue) -> Void

    /// The box type that enables `OnDeinit` to trigger its deinit action.
    ///
    /// It acts as the storage for all of the instance.
    @usableFromInline
    final class OnDeinitBox: Box {
        @usableFromInline
        var boxedValue: WrappedValue

        @usableFromInline
        var deinitAction: DeinitAction

        @usableFromInline
        init(boxedValue: WrappedValue, do deinitAction: @escaping DeinitAction) {
            self.boxedValue = boxedValue
            self.deinitAction = deinitAction
        }

        @usableFromInline
        deinit {
            deinitAction(boxedValue)
        }
    }

    @inlinable
    public var wrappedValue: WrappedValue {
        get { box.boxedValue }
        set { box.boxedValue = newValue }
        _modify {
            defer { _fixLifetime(self) }
            yield &box.boxedValue
        }
    }

    @usableFromInline
    var box: OnDeinitBox

    /// Creates an `@OnDeinit`.
    ///
    /// - Parameters:
    ///   - wrappedValue: The initial value of the `wrappedValue` property.
    ///   - deinitAction: The underlying function that should be called when this property wrapper goes out of scope.
    @inlinable
    @_transparent
    public init(wrappedValue: WrappedValue, do deinitAction: @escaping DeinitAction) {
        self.box = .init(boxedValue: wrappedValue, do: deinitAction)
    }

    /// Creates a copy of the `OnDeinit` that has the current `wrappedValue` and the `DeinitAction` the original instance was created with.
    ///
    /// - Warning: If you are using `OnDeinit` to trigger memory clean up you almost certainly do not want to call this function.
    ///     This is because the original deinitAction will be called for each instance of `OnDeinit` that has its `deinit` triggered.
    ///     If your `deinitAction` cleans up the same memory twice this will result in a crash or memory corruption.
    @inlinable
    public func unsafeCopy() -> Self {
        .init(wrappedValue: box.boxedValue, do: box.deinitAction)
    }

    /// If the backing memory is referenced by another instance than this instance then it copies its `wrappedValue` and `DeinitAction` into new backing storage.
    ///
    /// This is a no-op if the backing class instance is already uniquely owned by this `OnDeinit` instance.
    ///
    /// - Warning: This results in a copy being made so all warnings applicable to `OnDeinit.unsafeCopy()` are applicable to this function as well.
    @inlinable
    public mutating func unsafeMakeUnique() {
        guard !isKnownUniquelyReferenced(&box) else { return }
        self = unsafeCopy()
    }
}

extension OnDeinit: PassThroughEquatablePropertyWrapper where WrappedValue: Equatable {}
extension OnDeinit: PassThroughHashablePropertyWrapper where WrappedValue: Hashable {}
extension OnDeinit: PassThroughComparablePropertyWrapper where WrappedValue: Comparable {}

#if PROPERTYWRAPPER_ON_DEINIT_BUFFERED
// This is mostly all experimental stuff to learn more about how to work with ManagedBuffer and SafeManagedBuffer
// Performance wise it is WAY slower than the struct with a normal final class implimentation.

import SwiftMemoryManagementSpellBook

@propertyWrapper
public final class OnDeinitBuffered<WrappedValue>: SafeManagedBuffer<(WrappedValue) -> Void, WrappedValue>,
//SafeManagedBuffer<(WrappedValue) -> Void, WrappedValue>,
MutablePropertyWrapper, _OnDeinit {
    @inlinable
    public var wrappedValue: WrappedValue {
        get { withUnsafeMutablePointerToElements(\.pointee) }
        set { withUnsafeMutablePointerToElements { $0.pointee = newValue } }
        _modify {
            defer { _fixLifetime(self) }
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

extension OnDeinitBuffered: PassThroughEquatablePropertyWrapper where WrappedValue: Equatable {}
extension OnDeinitBuffered: PassThroughHashablePropertyWrapper where WrappedValue: Hashable {}
extension OnDeinitBuffered: PassThroughComparablePropertyWrapper where WrappedValue: Comparable {}
#endif
