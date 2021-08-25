//
//  _FromReferenceWritableKeyPath.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/16/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

/// A property wrapper to easily map key paths of other properties to vended properties on the same instance.
///
/// - Important:
///     This property wrapper can only be used inside of `AnyObject` types not structs.
///     This is because it must use a `ReferenceWritableKeyPath` to be able to access the value.
///
/// - Note:
///     The _ prefix is used because this uses private language features that haven't gone through Swift evolution.
///     Because of this it is not guaranteed to be stable but it should continue to work.
@propertyWrapper
public struct _FromReferenceWritableKeyPath<OuterSelf, WrappedValue> where OuterSelf: AnyObject {
    @available(*, unavailable, message: "You shouldn't directly access this property wrapper. It uses OuterSelf access so you need to directly access the property not this value.")
    public var wrappedValue: WrappedValue {
        get { fatalError("Unavailable") }
        set { fatalError("Unavailable") } // swiftlint:disable:this unused_setter_value
    }

    let writableKeyPath: ReferenceWritableKeyPath<OuterSelf, WrappedValue>!

    /// Creates a `_FromReferenceWritableKeyPath` with the given `ReferenceWritableKeyPath` value.
    ///
    /// - Parameter keyPath:
    ///     The `ReferenceWritableKeyPath` to follow on `OuterSelf` to get the value of this object.
    ///     Genrally this needs to be a fully qualified KeyPath in order for type checking to work.
    public init(_ writableKeyPath: ReferenceWritableKeyPath<OuterSelf, WrappedValue>) {
        self.writableKeyPath = writableKeyPath
    }

    public static subscript(
        _enclosingInstance instance: OuterSelf,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<OuterSelf, WrappedValue>,
        storage storageKeyPath: ReferenceWritableKeyPath<OuterSelf, Self>
    ) -> WrappedValue {
        get {
            let propertyWrapper = instance[keyPath: storageKeyPath]
            return instance[keyPath: propertyWrapper.writableKeyPath]
        }
        set {
            let propertyWrapper = instance[keyPath: storageKeyPath]
            instance[keyPath: propertyWrapper.writableKeyPath] = newValue
        }
        _modify {
            let propertyWrapper = instance[keyPath: storageKeyPath]
            yield &instance[keyPath: propertyWrapper.writableKeyPath]
        }
    }
}
