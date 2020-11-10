//
//  OSUnfairLock.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/9/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

#if canImport(os) && (os(iOS) || os(macOS) || os(watchOS) || os(tvOS))
import Foundation
import os

@available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *)
public final class OSUnfairLock: NSLocking {
    @usableFromInline
    var unfairLock: os_unfair_lock_t = .allocate(capacity: 1)

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
    public func lock() {
        os_unfair_lock_lock(unfairLock)
    }

    @inlinable
    public func unlock() {
        os_unfair_lock_unlock(unfairLock)
    }

    @inlinable
    public func `try`() -> Bool {
        os_unfair_lock_trylock(unfairLock)
    }

    @inlinable
    public func assertOwner() {
        os_unfair_lock_assert_owner(unfairLock)
    }

    @inlinable
    public func assertNotOwner() {
        os_unfair_lock_assert_not_owner(unfairLock)
    }
}

#endif
