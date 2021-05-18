//
//  Box.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 12/11/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

/// A common interface to put a box around a value.
public protocol Box {
    /// The type of value in this `Box`.
    associatedtype BoxedValue
    /// The value in the `Box`.
    var boxedValue: BoxedValue { get }
}

/// A common interface to put a box around a mutable value.
public protocol MutableBox: Box {
    /// The value in the `Box`.
    var boxedValue: BoxedValue { get set }
}

// Note: 12/11/20:
//  Ideally @dynamicMemberLookup would be implimented here on Box and MutableBox.
//  While it works just fine when you do this it breaks autocomplete...
//  So if you define the implimentations on all of the boxes directly then you get autocomplete.
