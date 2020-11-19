//
//  KeyPath.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/18/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

@inlinable
public prefix func ! <Root>(keyPath: KeyPath<Root, Bool>) -> (Root) -> Bool {
    { !$0[keyPath: keyPath] }
}
