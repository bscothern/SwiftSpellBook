//
//  FromSelfKeyPath.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/16/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

public struct FromSelfKeyPath<OuterSelf, WrappedValue> {
    @available(*, unavailable, message: "You shouldn't directly access this property wrapper. It uses OuterSelf access so you need to directly access the property not this value.")
    public var wrappedValue: WrappedValue {
        get { fatalError("Unavailable") }
        set { fatalError("Unavailable") }
    }

    let writableKeyPath: ReferenceWritableKeyPath<OuterSelf, WrappedValue>!
    let keyPath: KeyPath<OuterSelf, WrappedValue>!

    public init(_ writableKeyPath: ReferenceWritableKeyPath<OuterSelf, WrappedValue>) {
        self.writableKeyPath = writableKeyPath
        self.keyPath = nil
    }

    public init(_ keyPath: KeyPath<OuterSelf, WrappedValue>) {
        self.writableKeyPath = nil
        self.keyPath = keyPath
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

    public static subscript(
        _enclosingInstance instance: OuterSelf,
        wrapped wrappedKeyPath: KeyPath<OuterSelf, WrappedValue>,
        storage storageKeyPath: KeyPath<OuterSelf, Self>
    ) -> WrappedValue {
        let propertyWrapper = instance[keyPath: storageKeyPath]
        return instance[keyPath: propertyWrapper.keyPath]
    }
}
