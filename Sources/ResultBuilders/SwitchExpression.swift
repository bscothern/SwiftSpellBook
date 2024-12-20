//
//  SwitchExpression.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 10/30/20.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

#if swift(>=5.9)
/// A result builder that turns a switch into an expression
@available(*, unavailable, message: "This has been built into Swift since 5.9")
@resultBuilder
public enum SwitchExpression {
    public static func buildBlock<Result>(_ component: Result) -> Result {
        component
    }
}
#elseif swift(>=5.4)
/// A result builder that turns a switch into an expression
@resultBuilder
public enum SwitchExpression {}
/// A result builder that turns a switch into an expression
@_functionBuilder
public enum SwitchExpression {}
#endif

#if swift(<5.9)
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
#endif
