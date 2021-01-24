//
//  TryLocking.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 1/22/21.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if canImport(Foundation)
import Foundation

public protocol TryLocking {
    /// Attempts to aquire the lock.
    /// 
    /// - Returns: `true` if the lock was aquired, otherwise `false`.
    func `try`() -> Bool
}

extension NSLock: TryLocking {}
extension NSRecursiveLock: TryLocking {}

#endif
