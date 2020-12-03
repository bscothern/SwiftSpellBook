//
//  PassThroughCodablePropertyWrapper.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/2/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

/// A property type that can be both encoded and decoded to another type without storing any of its own data to be restored to a proper state.
public typealias PassThroughCodablePropertyWrapper = PassThroughEncodablePropertyWrapper & PassThroughDecodablePropertyWrapper
