//
//  Box.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 12/11/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

public protocol Box {
    associatedtype BoxedValue
    var boxedValue: BoxedValue { get }
}

public protocol MutableBox: Box {
    var boxedValue: BoxedValue { get set }
}

// Note: 12/11/20:
//  Ideally @dynamicMemberLookup would be implimented here on Box and MutableBox.
//  While it works just fine when you do this it break autocomplete...
//  So if you define the implimentations on all of the boxes directly then you get autocomplete.
