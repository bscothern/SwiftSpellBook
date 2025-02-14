//
//  FunctionArgumentsAsTuple.swift
//  SwiftSpellBook
//
//  Generated by gyb on 08/02/22.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

@_transparent
public func tupleArguments<T0, Value>(_ function: @escaping (T0) -> Value) -> ((T0)) -> Value {
    { t in
        function(t)
    }
}

@_transparent
public func tupleArguments<T0, Value>(_ function: @escaping @Sendable (T0) -> Value) -> @Sendable ((T0)) -> Value {
    { t in
        function(t)
    }
}

@_transparent
public func tupleArguments<T0, Value>(_ function: @escaping (T0) throws -> Value) -> ((T0)) throws -> Value {
    { t in
        try function(t)
    }
}

@_transparent
public func tupleArguments<T0, Value>(_ function: @escaping @Sendable (T0) throws -> Value) -> @Sendable ((T0)) throws -> Value {
    { t in
        try function(t)
    }
}

@_transparent
public func tupleArguments<T0, T1, Value>(_ function: @escaping (T0, T1) -> Value) -> ((T0, T1)) -> Value {
    { t in
        function(t.0, t.1)
    }
}

@_transparent
public func tupleArguments<T0, T1, Value>(_ function: @escaping @Sendable (T0, T1) -> Value) -> @Sendable ((T0, T1)) -> Value {
    { t in
        function(t.0, t.1)
    }
}

@_transparent
public func tupleArguments<T0, T1, Value>(_ function: @escaping (T0, T1) throws -> Value) -> ((T0, T1)) throws -> Value {
    { t in
        try function(t.0, t.1)
    }
}

@_transparent
public func tupleArguments<T0, T1, Value>(_ function: @escaping @Sendable (T0, T1) throws -> Value) -> @Sendable ((T0, T1)) throws -> Value {
    { t in
        try function(t.0, t.1)
    }
}

@_transparent
public func tupleArguments<T0, T1, T2, Value>(_ function: @escaping (T0, T1, T2) -> Value) -> ((T0, T1, T2)) -> Value {
    { t in
        function(t.0, t.1, t.2)
    }
}

@_transparent
public func tupleArguments<T0, T1, T2, Value>(_ function: @escaping @Sendable (T0, T1, T2) -> Value) -> @Sendable ((T0, T1, T2)) -> Value {
    { t in
        function(t.0, t.1, t.2)
    }
}

@_transparent
public func tupleArguments<T0, T1, T2, Value>(_ function: @escaping (T0, T1, T2) throws -> Value) -> ((T0, T1, T2)) throws -> Value {
    { t in
        try function(t.0, t.1, t.2)
    }
}

@_transparent
public func tupleArguments<T0, T1, T2, Value>(_ function: @escaping @Sendable (T0, T1, T2) throws -> Value) -> @Sendable ((T0, T1, T2)) throws -> Value {
    { t in
        try function(t.0, t.1, t.2)
    }
}

@_transparent
public func tupleArguments<T0, T1, T2, T3, Value>(_ function: @escaping (T0, T1, T2, T3) -> Value) -> ((T0, T1, T2, T3)) -> Value {
    { t in
        function(t.0, t.1, t.2, t.3)
    }
}

@_transparent
public func tupleArguments<T0, T1, T2, T3, Value>(_ function: @escaping @Sendable (T0, T1, T2, T3) -> Value) -> @Sendable ((T0, T1, T2, T3)) -> Value {
    { t in
        function(t.0, t.1, t.2, t.3)
    }
}

@_transparent
public func tupleArguments<T0, T1, T2, T3, Value>(_ function: @escaping (T0, T1, T2, T3) throws -> Value) -> ((T0, T1, T2, T3)) throws -> Value {
    { t in
        try function(t.0, t.1, t.2, t.3)
    }
}

@_transparent
public func tupleArguments<T0, T1, T2, T3, Value>(_ function: @escaping @Sendable (T0, T1, T2, T3) throws -> Value) -> @Sendable ((T0, T1, T2, T3)) throws -> Value {
    { t in
        try function(t.0, t.1, t.2, t.3)
    }
}

@_transparent
public func tupleArguments<T0, T1, T2, T3, T4, Value>(_ function: @escaping (T0, T1, T2, T3, T4) -> Value) -> ((T0, T1, T2, T3, T4)) -> Value {
    { t in
        function(t.0, t.1, t.2, t.3, t.4)
    }
}

@_transparent
public func tupleArguments<T0, T1, T2, T3, T4, Value>(_ function: @escaping @Sendable (T0, T1, T2, T3, T4) -> Value) -> @Sendable ((T0, T1, T2, T3, T4)) -> Value {
    { t in
        function(t.0, t.1, t.2, t.3, t.4)
    }
}

@_transparent
public func tupleArguments<T0, T1, T2, T3, T4, Value>(_ function: @escaping (T0, T1, T2, T3, T4) throws -> Value) -> ((T0, T1, T2, T3, T4)) throws -> Value {
    { t in
        try function(t.0, t.1, t.2, t.3, t.4)
    }
}

@_transparent
public func tupleArguments<T0, T1, T2, T3, T4, Value>(_ function: @escaping @Sendable (T0, T1, T2, T3, T4) throws -> Value) -> @Sendable ((T0, T1, T2, T3, T4)) throws -> Value {
    { t in
        try function(t.0, t.1, t.2, t.3, t.4)
    }
}

@_transparent
public func tupleArguments<T0, T1, T2, T3, T4, T5, Value>(_ function: @escaping (T0, T1, T2, T3, T4, T5) -> Value) -> ((T0, T1, T2, T3, T4, T5)) -> Value {
    { t in
        function(t.0, t.1, t.2, t.3, t.4, t.5)
    }
}

@_transparent
public func tupleArguments<T0, T1, T2, T3, T4, T5, Value>(_ function: @escaping @Sendable (T0, T1, T2, T3, T4, T5) -> Value) -> @Sendable ((T0, T1, T2, T3, T4, T5)) -> Value {
    { t in
        function(t.0, t.1, t.2, t.3, t.4, t.5)
    }
}

@_transparent
public func tupleArguments<T0, T1, T2, T3, T4, T5, Value>(_ function: @escaping (T0, T1, T2, T3, T4, T5) throws -> Value) -> ((T0, T1, T2, T3, T4, T5)) throws -> Value {
    { t in
        try function(t.0, t.1, t.2, t.3, t.4, t.5)
    }
}

@_transparent
public func tupleArguments<T0, T1, T2, T3, T4, T5, Value>(_ function: @escaping @Sendable (T0, T1, T2, T3, T4, T5) throws -> Value) -> @Sendable ((T0, T1, T2, T3, T4, T5)) throws -> Value {
    { t in
        try function(t.0, t.1, t.2, t.3, t.4, t.5)
    }
}

@_transparent
public func tupleArguments<T0, T1, T2, T3, T4, T5, T6, Value>(_ function: @escaping (T0, T1, T2, T3, T4, T5, T6) -> Value) -> ((T0, T1, T2, T3, T4, T5, T6)) -> Value {
    { t in
        function(t.0, t.1, t.2, t.3, t.4, t.5, t.6)
    }
}

@_transparent
public func tupleArguments<T0, T1, T2, T3, T4, T5, T6, Value>(_ function: @escaping @Sendable (T0, T1, T2, T3, T4, T5, T6) -> Value) -> @Sendable ((T0, T1, T2, T3, T4, T5, T6)) -> Value {
    { t in
        function(t.0, t.1, t.2, t.3, t.4, t.5, t.6)
    }
}

@_transparent
public func tupleArguments<T0, T1, T2, T3, T4, T5, T6, Value>(_ function: @escaping (T0, T1, T2, T3, T4, T5, T6) throws -> Value) -> ((T0, T1, T2, T3, T4, T5, T6)) throws -> Value {
    { t in
        try function(t.0, t.1, t.2, t.3, t.4, t.5, t.6)
    }
}

@_transparent
public func tupleArguments<T0, T1, T2, T3, T4, T5, T6, Value>(_ function: @escaping @Sendable (T0, T1, T2, T3, T4, T5, T6) throws -> Value) -> @Sendable ((T0, T1, T2, T3, T4, T5, T6)) throws -> Value {
    { t in
        try function(t.0, t.1, t.2, t.3, t.4, t.5, t.6)
    }
}

@_transparent
public func tupleArguments<T0, T1, T2, T3, T4, T5, T6, T7, Value>(_ function: @escaping (T0, T1, T2, T3, T4, T5, T6, T7) -> Value) -> ((T0, T1, T2, T3, T4, T5, T6, T7)) -> Value {
    { t in
        function(t.0, t.1, t.2, t.3, t.4, t.5, t.6, t.7)
    }
}

@_transparent
public func tupleArguments<T0, T1, T2, T3, T4, T5, T6, T7, Value>(_ function: @escaping @Sendable (T0, T1, T2, T3, T4, T5, T6, T7) -> Value) -> @Sendable ((T0, T1, T2, T3, T4, T5, T6, T7)) -> Value {
    { t in
        function(t.0, t.1, t.2, t.3, t.4, t.5, t.6, t.7)
    }
}

@_transparent
public func tupleArguments<T0, T1, T2, T3, T4, T5, T6, T7, Value>(_ function: @escaping (T0, T1, T2, T3, T4, T5, T6, T7) throws -> Value) -> ((T0, T1, T2, T3, T4, T5, T6, T7)) throws -> Value {
    { t in
        try function(t.0, t.1, t.2, t.3, t.4, t.5, t.6, t.7)
    }
}

@_transparent
public func tupleArguments<T0, T1, T2, T3, T4, T5, T6, T7, Value>(_ function: @escaping @Sendable (T0, T1, T2, T3, T4, T5, T6, T7) throws -> Value) -> @Sendable ((T0, T1, T2, T3, T4, T5, T6, T7)) throws -> Value {
    { t in
        try function(t.0, t.1, t.2, t.3, t.4, t.5, t.6, t.7)
    }
}

@_transparent
public func tupleArguments<T0, T1, T2, T3, T4, T5, T6, T7, T8, Value>(_ function: @escaping (T0, T1, T2, T3, T4, T5, T6, T7, T8) -> Value) -> ((T0, T1, T2, T3, T4, T5, T6, T7, T8)) -> Value {
    { t in
        function(t.0, t.1, t.2, t.3, t.4, t.5, t.6, t.7, t.8)
    }
}

@_transparent
public func tupleArguments<T0, T1, T2, T3, T4, T5, T6, T7, T8, Value>(_ function: @escaping @Sendable (T0, T1, T2, T3, T4, T5, T6, T7, T8) -> Value) -> @Sendable ((T0, T1, T2, T3, T4, T5, T6, T7, T8)) -> Value {
    { t in
        function(t.0, t.1, t.2, t.3, t.4, t.5, t.6, t.7, t.8)
    }
}

@_transparent
public func tupleArguments<T0, T1, T2, T3, T4, T5, T6, T7, T8, Value>(_ function: @escaping (T0, T1, T2, T3, T4, T5, T6, T7, T8) throws -> Value) -> ((T0, T1, T2, T3, T4, T5, T6, T7, T8)) throws -> Value {
    { t in
        try function(t.0, t.1, t.2, t.3, t.4, t.5, t.6, t.7, t.8)
    }
}

@_transparent
public func tupleArguments<T0, T1, T2, T3, T4, T5, T6, T7, T8, Value>(_ function: @escaping @Sendable (T0, T1, T2, T3, T4, T5, T6, T7, T8) throws -> Value) -> @Sendable ((T0, T1, T2, T3, T4, T5, T6, T7, T8)) throws -> Value {
    { t in
        try function(t.0, t.1, t.2, t.3, t.4, t.5, t.6, t.7, t.8)
    }
}

@_transparent
public func tupleArguments<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, Value>(_ function: @escaping (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9) -> Value) -> ((T0, T1, T2, T3, T4, T5, T6, T7, T8, T9)) -> Value {
    { t in
        function(t.0, t.1, t.2, t.3, t.4, t.5, t.6, t.7, t.8, t.9)
    }
}

@_transparent
public func tupleArguments<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, Value>(_ function: @escaping @Sendable (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9) -> Value) -> @Sendable ((T0, T1, T2, T3, T4, T5, T6, T7, T8, T9)) -> Value {
    { t in
        function(t.0, t.1, t.2, t.3, t.4, t.5, t.6, t.7, t.8, t.9)
    }
}

@_transparent
public func tupleArguments<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, Value>(_ function: @escaping (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9) throws -> Value) -> ((T0, T1, T2, T3, T4, T5, T6, T7, T8, T9)) throws -> Value {
    { t in
        try function(t.0, t.1, t.2, t.3, t.4, t.5, t.6, t.7, t.8, t.9)
    }
}

@_transparent
public func tupleArguments<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, Value>(_ function: @escaping @Sendable (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9) throws -> Value) -> @Sendable ((T0, T1, T2, T3, T4, T5, T6, T7, T8, T9)) throws -> Value {
    { t in
        try function(t.0, t.1, t.2, t.3, t.4, t.5, t.6, t.7, t.8, t.9)
    }
}
