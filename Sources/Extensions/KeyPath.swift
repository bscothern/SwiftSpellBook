//
//  KeyPath.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/18/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

@inlinable
public prefix func ! <Root>(keyPath: KeyPath<Root, Bool>) -> (Root) -> Bool {
    { !$0[keyPath: keyPath] }
}

@inlinable
public func == <Root, Value>(lhs: KeyPath<Root, Value>, rhs: Value) -> (Root) -> Bool where Value: Equatable {
    { root in
        root[keyPath: lhs] == rhs
    }
}
