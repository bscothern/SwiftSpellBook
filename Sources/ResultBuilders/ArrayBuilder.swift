//
//  ArrayBuilder.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 10/30/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

@_functionBuilder
public enum ArrayBuilder<Element> {
    public static func buildBlock(_ elements: Element...) -> [Element] {
        elements
    }
}
