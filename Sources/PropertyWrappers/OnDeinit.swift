//
//  OnDeinit.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 10/30/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

@propertyWrapper
public final class OnDeinit<WrappedValue> {
    public var wrappedValue: WrappedValue
    
    @usableFromInline
    var deinitFunction: (WrappedValue) -> Void
    
    @inlinable
    public init(wrappedValue: WrappedValue, do deinitFunction: @escaping (WrappedValue) -> Void) {
        self.wrappedValue = wrappedValue
        self.deinitFunction = deinitFunction
    }

    @inlinable
    deinit {
        deinitFunction(wrappedValue)
    }
}
