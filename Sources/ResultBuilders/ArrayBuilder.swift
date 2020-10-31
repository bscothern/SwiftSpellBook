//
//  ArrayBuilder.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 10/30/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

/// A result builder that collects instances into an array.
@_functionBuilder
public enum ArrayBuilder<Element> {
    public static func buildBlock(_ components: Element) -> [Element] {
        [components]
    }

    public static func buildBlock(_ components: Element...) -> [Element] {
        components
    }
}
