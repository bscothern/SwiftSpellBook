//
//  TryLocking.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 1/22/21.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

#if canImport(Foundation)
import Foundation

public protocol TryLocking: NSLocking {
    /// Attempts to aquire the lock.
    ///
    /// - Note:
    ///     It is invalid to surround calls to this function with a retry loop.
    ///     If this function returns `false`, the program must be able to proceed without having acquired the lock, or it must call `lock()` directly.
    ///     A retry loop around `try()` amounts to an inefficient implementation of `lock()` that hides the lock waiter from the system and prevents resolution of priority inversions.
    ///
    /// - Returns: `true` if the lock was aquired, otherwise `false`.
    func `try`() -> Bool
}

extension NSLock: TryLocking {}
extension NSRecursiveLock: TryLocking {}

#endif
