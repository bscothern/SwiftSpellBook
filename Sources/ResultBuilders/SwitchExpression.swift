//
//  SwitchExpression.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 10/30/20.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

#if swift(>=5.4)
/// A result builder that turns a switch into an expression
@resultBuilder
public enum SwitchExpression {}
#else
/// A result builder that turns a switch into an expression
@_functionBuilder
public enum SwitchExpression {}
#endif

extension SwitchExpression {
    public static func buildBlock<Result>(_ component: Result) -> Result {
        component
    }

    public static func buildEither<Result>(first component: Result) -> Result {
        component
    }

    public static func buildEither<Result>(second component: Result) -> Result {
        component
    }
}
