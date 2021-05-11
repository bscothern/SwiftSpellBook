//
//  SwitchExpression.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 10/30/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if swift(>=5.4)
/// A result builder that turns a switch into an expression
@resultBuilder
public enum SwitchExpression<Result> {
    public static func buildBlock(_ component: Result) -> Result {
        component
    }

    public static func buildEither(first component: Result) -> Result {
        component
    }

    public static func buildEither(second component: Result) -> Result {
        component
    }
}
#endif
