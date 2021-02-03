//
//  Collection+KeyPath.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/18/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if swift(<5.2)
extension Collection {
    @inlinable
    public func drop(while keyPath: KeyPath<Element, Bool>) -> DropWhileSequence<Self> {
        drop(while:) { $0[keyPath: keyPath] }
    }

    @inlinable
    public func firstIndex(where keyPath: KeyPath<Element, Bool>) -> Index? {
        firstIndex(where:) { $0[keyPath: keyPath] }
    }

    @inlinable
    public func prefix(while keyPath: KeyPath<Element, Bool>) -> SubSequence {
        prefix(while:) { $0[keyPath: keyPath] }
    }
}
#endif
