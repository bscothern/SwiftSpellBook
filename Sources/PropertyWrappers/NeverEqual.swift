//
//  NeverEqual.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 10/30/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

public struct NeverEqual<WrappedValue>: Equatable {
    public var wrappedValue: WrappedValue
    
    @inlinable
    public init(wrappedValue: WrappedValue) {
        self.wrappedValue = wrappedValue
    }
    
    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        false
    }
}
