//
//  _FromKeyPath.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 5/3/21.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if PROPERTYWRAPPER_FROM_KEY_PATH

/// A property wrapper to easily map key paths of other properties to vended properties on the same instance.
///
/// - Note: The _ prefix is used because this uses private language features that haven't gone through Swift evolution.
///     Because of this it is not guaranteed to be stable but it should continue to work.
@propertyWrapper
public struct _FromKeyPath<OuterSelf, WrappedValue> where OuterSelf: AnyObject {
    @available(*, unavailable, message: "You shouldn't directly access this property wrapper. It uses OuterSelf access so you need to directly access the property not this value.")
    public var wrappedValue: WrappedValue {
        get { fatalError("Unavailable") }
        set { fatalError("Unavailable") } //swiftlint:disable:this unused_setter_value
    }

    let keyPath: KeyPath<OuterSelf, WrappedValue>!

    public init(_ keyPath: KeyPath<OuterSelf, WrappedValue>) {
        self.keyPath = keyPath
    }

    public static subscript(
        _enclosingInstance instance: OuterSelf,
        wrapped wrappedKeyPath: KeyPath<OuterSelf, WrappedValue>,
        storage storageKeyPath: KeyPath<OuterSelf, Self>
    ) -> WrappedValue {
        let propertyWrapper = instance[keyPath: storageKeyPath]
        return instance[keyPath: propertyWrapper.keyPath]
    }
}

#endif
