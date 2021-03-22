//
//  ArrayBuilder.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 10/30/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if swift(>=5.4)
/// A result builxder that collects instances into an array.
@resultBuilder
public enum ArrayBuilder<Element> {
    public static func buildBlock(_ components: Element) -> [Element] {
        [components]
    }

    public static func buildBlock(_ components: Element...) -> [Element] {
        components
    }
}
#endif
