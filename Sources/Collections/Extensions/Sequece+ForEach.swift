//
//  Sequence+ForEach.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/18/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

extension Sequence {
    @inlinable
    public func forEach(execute: (Element) -> () -> Void) {
        forEach { element in
            execute(element)()
        }
    }
}
