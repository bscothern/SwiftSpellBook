//
//  Array.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/10/20.
//  Copyright © 2020-2022 Braden Scothern. All rights reserved.
//

extension Array {
    @inlinable
    public init(minimumCapacity: Int) {
        self.init(unsafeUninitializedCapacity: minimumCapacity) { _, count in
            count = 0
        }
    }
}
