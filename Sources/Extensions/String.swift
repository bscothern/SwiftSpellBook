//
//  String.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 1/22/21.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
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
