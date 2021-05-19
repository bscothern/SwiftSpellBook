//
//  Locked.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/9/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if canImport(Foundation)
import Foundation

// Should this be a class instead of a struct so we share the value instead of copy it if you access the proeprty wrapper or pass it around?
@propertyWrapper
public struct Locked<WrappedValue>: MutablePropertyWrapper {
    @usableFromInline
    var value: WrappedValue

    @usableFromInline
    let lock: NSLocking & TryLocking

    @inlinable
    @_transparent
    public var wrappedValue: WrappedValue {
        get {
            lock.lock()
            defer { lock.unlock() }
            return value
        }
        set {
            lock.lock()
            defer { lock.unlock() }
            value = newValue
        }
        _modify {
            lock.lock()
            defer { lock.unlock() }
            var value = withUnsafeMutablePointer(to: &self.value) { valuePointer in
                valuePointer.move()
            }
            defer {
                withUnsafeMutablePointer(to: &self.value) { valuePointer in
                    valuePointer.initialize(to: value)
                }
            }
            yield &value
        }
    }

    @inlinable
    public var projectedValue: Self {
        get { self } //swiftlint:disable:this implicit_getter
        _modify {
            defer { _fixLifetime(self) }
            yield &self
        }
    }

    @usableFromInline
    init(wrappedValue: WrappedValue, lock: NSLocking & TryLocking) {
        self.value = wrappedValue
        self.lock = lock
    }

    /// Creates a `Locked`.
    ///
    /// - Parameters:
    ///   - wrappedValue: The initial value to contain in the `Locked` instance.
    ///   - lockType: The type of lock used to protect access to the `wrappedValue`.
    @inlinable
    public init(wrappedValue: WrappedValue, lockType: LockType = .platformDefault) {
        self.init(wrappedValue: wrappedValue, lock: lockType.createLock())
    }
}
#else
@available(*, unavailable, message: "@Locked requires Foundation be available on this platform")
@propertyWrapper
public struct Locked<WrappedValue> {
    public var wrappedValue: WrappedValue

    public init(lock: LockType = .platformDefault, wrappedValue: WrappedValue) {
        fatalError("unavailable")
    }
}
#endif

extension Locked {
    public enum LockType {
        //swiftlint:disable duplicate_enum_cases

        /// Specifies the `Foundation.NSLock` type.
        case nsLock

        /// Specifies the `Foundation.NSRecursiveLock` type.
        case nsRecursiveLock

        #if canImport(os) && (os(iOS) || os(macOS) || os(watchOS) || os(tvOS))
        /// Specifies the `OSUnfairLock` type.
        @available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *)
        case osUnfairLock
        #else
        /// Specifies the `OSUnfairLock` type.
        @available(*, unavailable, message: "OSUnfairLock is only available on Apple platforms.")
        case osUnfairLock
        #endif

        //swiftlint:enable duplicate_enum_cases

        /// The default lock type to use on each platform.
        ///
        /// It is potentially different for each platform to gain the best performance available.
        @inlinable
        public static var platformDefault: Self {
            #if canImport(os) && (os(iOS) || os(macOS) || os(watchOS) || os(tvOS))
            if #available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *) {
                return .osUnfairLock
            }
            #endif
            return .nsLock
        }

        #if canImport(Foundation)
        @usableFromInline
        func createLock() -> NSLocking & TryLocking {
            switch self {
            case .osUnfairLock:
                guard #available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *) else {
                    fatalError("Unavailable")
                }
                return OSUnfairLock()
            case .nsLock:
                return NSLock()
            case .nsRecursiveLock:
                return NSRecursiveLock()
            }
        }
        #endif
    }
}

extension Locked {
    /// Allows you to access the `wrappedValue` of the `Locked` instance for the scope of the `criticalBlock`.
    ///
    /// - Parameter criticalBlock: A block which will have exclusive read access to the `wrappedValue` for its scope.
    /// - Returns: The return value of `criticalBlock`.
    @inlinable
    public func use<Result>(_ criticalBlock: (WrappedValue) throws -> Result) rethrows -> Result {
        lock.lock()
        defer { lock.unlock() }
        return try criticalBlock(value)
    }

    /// Allows you to access and modify the `wrappedValue` of the `Locked` instance for the scope of the `criticalBlock`.
    ///
    /// - Parameter criticalBlock: A block which will have exclusive read and write access to the `wrappedValue` for its scope.
    /// - Returns: The return value of `criticalBlock`.
    @inlinable
    public mutating func modify<Result>(_ criticalBlock: (inout WrappedValue) throws -> Result) rethrows -> Result {
        lock.lock()
        defer { lock.unlock() }
        return try criticalBlock(&value)
    }

    /// Allows you to access the `wrappedValue` of the `Locked` instance for the scope of the `criticalBlock` if the lock can successfully be acquired without waiting.
    ///
    /// - Parameter criticalBlock: A block which will have exclusive read access to the `wrappedValue` for its scope.
    /// - Returns: The return value of `criticalBlock` if it was executed, otherwise `nil`.
    @inlinable
    public func tryUse<Result>(_ criticalBlock: (WrappedValue) throws -> Result) rethrows -> Result? {
        guard lock.try() else {
            return nil
        }
        defer { lock.unlock() }
        return try criticalBlock(value)
    }

    /// Allows you to access and modify the `wrappedValue` of the `Locked` instance for the scope of the `criticalBlock` if the lock can successfully be acquired without waiting.
    ///
    /// - Parameter criticalBlock: A block which will have exclusive read and write access to the `wrappedValue` for its scope.
    /// - Returns: The return value of `criticalBlock` if it was executed, otherwise `nil`.
    @inlinable
    public mutating func tryModify<Result>(_ criticalBlock: (inout WrappedValue) throws -> Result) rethrows -> Result? {
        guard lock.try() else {
            return nil
        }
        defer { lock.unlock() }
        return try criticalBlock(&value)
    }
}

extension Locked: PassThroughEquatablePropertyWrapper where WrappedValue: Equatable {}
extension Locked: PassThroughHashablePropertyWrapper where WrappedValue: Hashable {}
extension Locked: PassThroughComparablePropertyWrapper where WrappedValue: Comparable {}
