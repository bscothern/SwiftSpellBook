//
//  NSLocking+Closures.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/9/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if canImport(Foundation)
import Foundation

extension NSLocking {
    @inlinable
    @discardableResult
    public func protect<T>(_ criticalBlock: () throws -> T) rethrows -> T {
        lock()
        defer { unlock() }
        return try criticalBlock()
    }
}
#endif
