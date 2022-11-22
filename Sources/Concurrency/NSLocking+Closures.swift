//
//  NSLocking+Closures.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/9/20.
//  Copyright © 2020-2022 Braden Scothern. All rights reserved.
//

#if canImport(Foundation)
import Foundation

extension NSLocking {
    /// Creates a protected scope of code that ensures it is locked on entry and unlocked on exit.
    ///
    /// - Parameter criticalBlock: A block of code that should execute while locked.
    /// - Returns: The result of `criticalBlock`.
    @inlinable
    @discardableResult
    public func protect<T>(_ criticalBlock: () throws -> T) rethrows -> T {
        lock()
        defer { unlock() }
        return try criticalBlock()
    }
}
#endif
