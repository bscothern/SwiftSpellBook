//
//  PropertyWrapper.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/2/20.
//  Copyright © 2020-2022 Braden Scothern. All rights reserved.
//

// MARK: - PropertyWrapper

/// The basic requirements of a property wrapper type.
public protocol PropertyWrapper {
    /// The type vended by a property wrapper.
    associatedtype WrappedValue
    /// The value of the property wrapper.
    var wrappedValue: WrappedValue { get }
}

// MARK: - MutablePropertyWrapper
public protocol MutablePropertyWrapper: PropertyWrapper {
    /// The value of the property wrapper.
    var wrappedValue: WrappedValue { get set }
}

// MARK: - DefaultInitializablePropertyWrapper
/// A property wrapper that can be created by just assigning its wrapped value.
///
/// An example of what this enables is syntax like this:
/// ```swift
/// @ExamplePropertyWrapper var foo = 1
/// ```
public protocol DefaultInitializablePropertyWrapper: PropertyWrapper {
    /// The default init used on a property wrapper when it takes no other arguments.
    /// This allows for traditional property assignment syntax.
    init(wrappedValue: WrappedValue)
}

// MARK: - ProjectedPropertyWrapper
/// A property wrapper with a projected value.
public protocol ProjectedPropertyWrapper: PropertyWrapper {
    /// The type vended by the projected value of the property wrapper.
    associatedtype ProjectedValue
    /// The projected value of the property wrapper.
    var projectedValue: ProjectedValue { get }
}

// MARK: - MutableProjectedPropertyWrapper
public protocol MutableProjectedPropertyWrapper: ProjectedPropertyWrapper {
    /// The projected value of the property wrapper.
    var projectedValue: ProjectedValue { get set }
}
