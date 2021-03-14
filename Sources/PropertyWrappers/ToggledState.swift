//
//  ToggledState.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 3/4/21.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

@propertyWrapper
public struct ToggledState<State> where State: Hashable {
    public var wrappedValue: [State: Bool]

    public var projectedValue: Self {
        get { self }
        set { self = newValue }
        _modify {
            _fixLifetime(self)
            yield &self
        }
    }

    public var defaultToggleValue: Bool

    @inlinable
    public init() {
        self.init(wrappedValue: [:], defaultToggleValue: false)
    }

    @inlinable
    public init(wrappedValue: [State: Bool]) {
        self.init(wrappedValue: wrappedValue, defaultToggleValue: false)
    }

    @inlinable
    public init(wrappedValue: [State]) {
        self.init(
            wrappedValue: .init(
                wrappedValue.lazy.map { ($0, false) },
                uniquingKeysWith: { _, _ in false }
            ),
            defaultToggleValue: false
        )
    }

    @inlinable
    public init(defaultToggleValue: Bool) {
        self.init(wrappedValue: [:], defaultToggleValue: defaultToggleValue)
    }

    @inlinable
    public init(wrappedValue: [State: Bool], defaultToggleValue: Bool) {
        self.wrappedValue = wrappedValue
        self.defaultToggleValue = defaultToggleValue
    }
}

extension ToggledState: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (State, Bool)...) {
        self.init(
            wrappedValue: .init(
                elements,
                uniquingKeysWith: { first, _ in first }
            ),
            defaultToggleValue: false
        )
    }
}

extension ToggledState: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: State...) {
        self.init(wrappedValue: elements)
    }
}

extension ToggledState {
    @inlinable
    public subscript (state: State) -> Bool {
        get {
            wrappedValue[state, default: defaultToggleValue]
        }
        set {
            wrappedValue[state] = newValue
        }
        _modify {
            _fixLifetime(self)
            yield &wrappedValue[state, default: defaultToggleValue]
        }
    }
}

extension ToggledState {
    @inlinable
    public func callAsFunction(_ state: State) -> Bool {
        wrappedValue[state, default: defaultToggleValue]
    }
}
