//
//  ArrayBuilder.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 10/30/20.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

#if swift(>=5.4)
/// A result builxder that collects instances into an array.
@resultBuilder
public enum ArrayBuilder {}
#else
/// A result builxder that collects instances into an array.
@_functionBuilder
public enum ArrayBuilder {}
#endif

extension ArrayBuilder {
    public static func buildBlock<Element>(_ components: [Element]...) -> [Element] {
        components.flatMap { $0 }
    }

    public static func buildExpression<Element>(_ expression: Element) -> [Element] {
        [expression]
    }

    public static func buildOptional<Element>(_ component: [Element]?) -> [Element] {
        component ?? []
    }

    public static func buildEither<Element>(first component: [Element]) -> [Element] {
        component
    }

    public static func buildEither<Element>(second component: [Element]) -> [Element] {
        component
    }

    public static func buildArray<Element>(_ components: [[Element]]) -> [Element] {
        components.flatMap { $0 }
    }

    public static func buildLimitedAvailability<Element>(_ component: [Element]) -> [Element] {
        component
    }
}
