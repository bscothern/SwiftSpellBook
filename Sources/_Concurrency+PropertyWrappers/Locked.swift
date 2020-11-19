//
//  Locked.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/9/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

#if canImport(Foundation)
import Foundation

// Should this be a class instead of a struct so we share the value instead of copy it if you access the proeprty wrapper or pass it around?
@propertyWrapper
public struct Locked<WrappedValue> {
    @usableFromInline
    var value: WrappedValue

    @usableFromInline
    let lock: NSLocking

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
            yield &value
        }
    }

    @inlinable
    public var projectedValue: Self { self }

    @inlinable
    public init(lockType: LockType = .platformDefault, wrappedValue: WrappedValue) {
        self.lock = lockType.createLock()
        self.value = wrappedValue
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
        case nsLock
        case nsRecursiveLock

        #if canImport(os) && (os(iOS) || os(macOS) || os(watchOS) || os(tvOS))
        @available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *)
        case osUnfairLock
        #else
        @available(*, unavailable, message: "OSUnfairLock is only available on Apple platforms.")
        case osUnfairLock
        #endif

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
        func createLock() -> NSLocking {
            switch self {
            case .osUnfairLock:
                if #available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *) {
                    return OSUnfairLock()
                } else {
                    fatalError("Unavailable")
                }
            case .nsLock:
                return NSLock()
            case .nsRecursiveLock:
                return NSRecursiveLock()
            }
        }
        #endif
    }
}
