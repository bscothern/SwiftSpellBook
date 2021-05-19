//
//  OSUnfairLock.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/9/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if canImport(Foundation) && canImport(os) && (os(iOS) || os(macOS) || os(watchOS) || os(tvOS))
import Foundation
import os

/// A lock that allows waiters to block efficiently on contention.
///
/// - Important:
///     You must unlock this lock from the same thread that locked it.
///     Attempts to unlock from a different thread will cause an assertion aborting the process.
///
/// - Important:
///     There is no attempt at fairness or lock ordering.
///     e.g. an unlocker can potentially immediately reacquire the lock before a woken up waiter gets an opportunity to attempt to acquire the lock.
///     This may be advantageous for performance reasons, but also makes starvation of waiters a possibility.
@available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *)
public final class OSUnfairLock: NSLocking, TryLocking {
    @usableFromInline
    var unfairLock: os_unfair_lock_t = .allocate(capacity: 1)

    /// Creates an `OSUnfairLock`
    @inlinable
    public init() {
        unfairLock.initialize(to: .init())
    }

    @inlinable
    deinit {
        unfairLock.deinitialize(count: 1)
        unfairLock.deallocate()
    }

    @inlinable
    @inline(__always)
    public func lock() {
        os_unfair_lock_lock(unfairLock)
    }

    @inlinable
    @inline(__always)
    public func unlock() {
        os_unfair_lock_unlock(unfairLock)
    }

    @inlinable
    @inline(__always)
    public func `try`() -> Bool {
        os_unfair_lock_trylock(unfairLock)
    }

    /// Asserts that the calling thread is the current owner of this lock.
    ///
    /// If the lock is currently owned by the calling thread, this function returns.
    ///
    /// If the lock is unlocked or owned by a different thread, this function asserts and terminates the process.
    @inlinable
    @inline(__always)
    public func assertOwner() {
        os_unfair_lock_assert_owner(unfairLock)
    }

    /// Asserts that the calling thread is not the current owner of this lock.
    ///
    /// If the lock is unlocked or owned by a different thread, this function returns.
    ///
    /// If the lock is currently owned by the current thread, this function asserts and terminates the process.
    @inlinable
    @inline(__always)
    public func assertNotOwner() {
        os_unfair_lock_assert_not_owner(unfairLock)
    }
}
#endif
