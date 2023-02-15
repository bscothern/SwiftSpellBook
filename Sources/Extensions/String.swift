//
//  String.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 1/22/21.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

// MARK: - StaticString Support
extension String {
    /// Creates a `String` from a `StaticString`
    ///
    /// - Parameter staticString: The `StaticString` to create a copy of as a normal `String`
    @inlinable
    public init(_ staticString: StaticString) {
        if staticString.hasPointerRepresentation {
            self = staticString.withUTF8Buffer { utf8Buffer in
                guard !utf8Buffer.isEmpty else {
                    return ""
                }
                return String(cString: utf8Buffer.baseAddress!)
            }
        } else {
            self = String(staticString.unicodeScalar)
        }
    }
}

// MARK: - Component Removal
extension String {
    /// If the provided prefix is the start of the `String` then it is removed.
    ///
    /// For more info see the standard libraries `String.hasPrefix(_:)`.
    ///
    /// - Complexity: `O(N)` where `N` is the length of the prefix.
    /// - Parameter prefix: The prefix to look for and remove from the start of the `String` if found.
    /// - Returns: `true` if the prefix was found and removed, otherwise `false`.
    @inlinable
    @discardableResult
    public mutating func removePrefix<S>(_ prefix: S) -> Bool where S: StringProtocol {
        guard self.hasPrefix(prefix) else {
            return false
        }
        self.removeFirst(prefix.count)
        return true
    }
    
    /// Create a copy of the string and remove the provided prefix if it is found at the start of the string.
    ///
    /// For more info see the standard libraries `String.hasPrefix(_:)`.
    ///
    /// - Complexity: `O(N)` where `N` is the length of the prefix.
    /// - Parameter prefix: The prefix to look for and remove from the start of the `String` if found.
    /// - Returns: A copy of the string with the prefix removed if it was found.
    public func removedPrefix<S>(_ prefix: S) -> String where S: StringProtocol {
        var copy = self
        copy.removePrefix(prefix)
        return copy
    }

    /// If the provided suffix is the end of the `String` then it is removed.
    ///
    /// For more info see the standard libraries `String.hasSuffix(_:)`.
    ///
    /// - Complexity: `O(N)` where `N` is the length of the suffix.
    /// - Parameter suffix: The suffix to look for and remove from the end of the `String` if found.
    /// - Returns: `true` if the suffix was found and removed, otherwise `false`.
    @inlinable
    @discardableResult
    public mutating func removeSuffix<S>(_ suffix: S) -> Bool where S: StringProtocol {
        guard self.hasSuffix(suffix) else {
            return false
        }
        self.removeLast(suffix.count)
        return true
    }
    
    /// Create a copy of the string and remove the provided suffix if it is found at the end of the string.
    ///
    /// For more info see the standard libraries `String.hasSuffix(_:)`.
    ///
    /// - Complexity: `O(N)` where `N` is the length of the suffix.
    /// - Parameter suffix: The suffix to look for and remove from the end of the `String` if found.
    /// - Returns: A copy of the string with the suffix removed if it was found.
    public func removedSuffix<S>(_ suffix: S) -> String where S: StringProtocol {
        var copy = self
        copy.removeSuffix(suffix)
        return copy
    }
}
