//
//  Sequence+Tuples.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 12/11/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

extension Sequence {
    @inlinable
    public func map<Value0, Value1>(_ value0KeyPath: KeyPath<Element, Value0>, _ value1KeyPath: KeyPath<Element, Value1>) -> [(Value0, Value1)] {
        map { element in
            (element[keyPath: value0KeyPath], element[keyPath: value1KeyPath])
        }
    }

    @inlinable
    public func map<Value0, Value1, Value2>(_ value0KeyPath: KeyPath<Element, Value0>, _ value1KeyPath: KeyPath<Element, Value1>, _ value2KeyPath: KeyPath<Element, Value2>) -> [(Value0, Value1, Value2)] {
        map { element in
            (element[keyPath: value0KeyPath], element[keyPath: value1KeyPath], element[keyPath: value2KeyPath])
        }
    }
}
