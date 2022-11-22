//
//  _FromKeyPath.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 5/3/21.
//  Copyright © 2020-2022 Braden Scothern. All rights reserved.
//

#if PROPERTYWRAPPER_FROM_KEY_PATH

/// A property wrapper to easily map key paths of other properties to vended properties on the same instance.
///
/// - Note: The _ prefix is used because this uses private language features that haven't gone through Swift evolution.
///     Because of this it is not guaranteed to be stable but it should continue to work.
@propertyWrapper
public struct _FromKeyPath<OuterSelf, WrappedValue> where OuterSelf: AnyObject {
    @available(*, unavailable, message: "You shouldn't directly access this property wrapper. It uses OuterSelf access so you need to directly access the property not this value.")
    public var wrappedValue: WrappedValue { // swiftlint:disable:this missing_docs
        get { fatalError("Unavailable") }
        set { fatalError("Unavailable") } // swiftlint:disable:this unused_setter_value
    }

    let keyPath: KeyPath<OuterSelf, WrappedValue>!

    /// Creates a `_FromKeyPath` with the given `KeyPath` value.
    ///
    /// - Parameter keyPath:
    ///     The `KeyPath` to follow on `OuterSelf` to get the value of this object.
    ///     Genrally this needs to be a fully qualified KeyPath in order for type checking to work.
    public init(_ keyPath: KeyPath<OuterSelf, WrappedValue>) {
        self.keyPath = keyPath
    }

    public static subscript( // swiftlint:disable:this missing_docs
        _enclosingInstance instance: OuterSelf,
        wrapped wrappedKeyPath: KeyPath<OuterSelf, WrappedValue>,
        storage storageKeyPath: KeyPath<OuterSelf, Self>
    ) -> WrappedValue {
        let propertyWrapper = instance[keyPath: storageKeyPath]
        return instance[keyPath: propertyWrapper.keyPath]
    }
}

#endif
