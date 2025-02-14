//
//  FunctionArgumentsBind.swift
//  SwiftSpellBook
//
//  Generated by gyb on 11/21/22.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, Value>(arg1: T1, into function: @escaping (T1) -> Value) -> () -> Value {
    {
        function(arg1)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, Value>(arg1: T1, into function: @escaping (T1, T2) -> Value) -> (T2) -> Value {
    { arg2 in
        function(arg1, arg2)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, Value>(arg2: T2, into function: @escaping (T1, T2) -> Value) -> (T1) -> Value {
    { arg1 in
        function(arg1, arg2)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, Value>(arg1: T1, into function: @escaping (T1, T2, T3) -> Value) -> (T2, T3) -> Value {
    { arg2, arg3 in
        function(arg1, arg2, arg3)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, Value>(arg2: T2, into function: @escaping (T1, T2, T3) -> Value) -> (T1, T3) -> Value {
    { arg1, arg3 in
        function(arg1, arg2, arg3)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, Value>(arg3: T3, into function: @escaping (T1, T2, T3) -> Value) -> (T1, T2) -> Value {
    { arg1, arg2 in
        function(arg1, arg2, arg3)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, Value>(arg1: T1, into function: @escaping (T1, T2, T3, T4) -> Value) -> (T2, T3, T4) -> Value {
    { arg2, arg3, arg4 in
        function(arg1, arg2, arg3, arg4)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, Value>(arg2: T2, into function: @escaping (T1, T2, T3, T4) -> Value) -> (T1, T3, T4) -> Value {
    { arg1, arg3, arg4 in
        function(arg1, arg2, arg3, arg4)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, Value>(arg3: T3, into function: @escaping (T1, T2, T3, T4) -> Value) -> (T1, T2, T4) -> Value {
    { arg1, arg2, arg4 in
        function(arg1, arg2, arg3, arg4)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, Value>(arg4: T4, into function: @escaping (T1, T2, T3, T4) -> Value) -> (T1, T2, T3) -> Value {
    { arg1, arg2, arg3 in
        function(arg1, arg2, arg3, arg4)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, T5, Value>(arg1: T1, into function: @escaping (T1, T2, T3, T4, T5) -> Value) -> (T2, T3, T4, T5) -> Value {
    { arg2, arg3, arg4, arg5 in
        function(arg1, arg2, arg3, arg4, arg5)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, T5, Value>(arg2: T2, into function: @escaping (T1, T2, T3, T4, T5) -> Value) -> (T1, T3, T4, T5) -> Value {
    { arg1, arg3, arg4, arg5 in
        function(arg1, arg2, arg3, arg4, arg5)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, T5, Value>(arg3: T3, into function: @escaping (T1, T2, T3, T4, T5) -> Value) -> (T1, T2, T4, T5) -> Value {
    { arg1, arg2, arg4, arg5 in
        function(arg1, arg2, arg3, arg4, arg5)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, T5, Value>(arg4: T4, into function: @escaping (T1, T2, T3, T4, T5) -> Value) -> (T1, T2, T3, T5) -> Value {
    { arg1, arg2, arg3, arg5 in
        function(arg1, arg2, arg3, arg4, arg5)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, T5, Value>(arg5: T5, into function: @escaping (T1, T2, T3, T4, T5) -> Value) -> (T1, T2, T3, T4) -> Value {
    { arg1, arg2, arg3, arg4 in
        function(arg1, arg2, arg3, arg4, arg5)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, T5, T6, Value>(arg1: T1, into function: @escaping (T1, T2, T3, T4, T5, T6) -> Value) -> (T2, T3, T4, T5, T6) -> Value {
    { arg2, arg3, arg4, arg5, arg6 in
        function(arg1, arg2, arg3, arg4, arg5, arg6)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, T5, T6, Value>(arg2: T2, into function: @escaping (T1, T2, T3, T4, T5, T6) -> Value) -> (T1, T3, T4, T5, T6) -> Value {
    { arg1, arg3, arg4, arg5, arg6 in
        function(arg1, arg2, arg3, arg4, arg5, arg6)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, T5, T6, Value>(arg3: T3, into function: @escaping (T1, T2, T3, T4, T5, T6) -> Value) -> (T1, T2, T4, T5, T6) -> Value {
    { arg1, arg2, arg4, arg5, arg6 in
        function(arg1, arg2, arg3, arg4, arg5, arg6)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, T5, T6, Value>(arg4: T4, into function: @escaping (T1, T2, T3, T4, T5, T6) -> Value) -> (T1, T2, T3, T5, T6) -> Value {
    { arg1, arg2, arg3, arg5, arg6 in
        function(arg1, arg2, arg3, arg4, arg5, arg6)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, T5, T6, Value>(arg5: T5, into function: @escaping (T1, T2, T3, T4, T5, T6) -> Value) -> (T1, T2, T3, T4, T6) -> Value {
    { arg1, arg2, arg3, arg4, arg6 in
        function(arg1, arg2, arg3, arg4, arg5, arg6)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, T5, T6, Value>(arg6: T6, into function: @escaping (T1, T2, T3, T4, T5, T6) -> Value) -> (T1, T2, T3, T4, T5) -> Value {
    { arg1, arg2, arg3, arg4, arg5 in
        function(arg1, arg2, arg3, arg4, arg5, arg6)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, T5, T6, T7, Value>(arg1: T1, into function: @escaping (T1, T2, T3, T4, T5, T6, T7) -> Value) -> (T2, T3, T4, T5, T6, T7) -> Value {
    { arg2, arg3, arg4, arg5, arg6, arg7 in
        function(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, T5, T6, T7, Value>(arg2: T2, into function: @escaping (T1, T2, T3, T4, T5, T6, T7) -> Value) -> (T1, T3, T4, T5, T6, T7) -> Value {
    { arg1, arg3, arg4, arg5, arg6, arg7 in
        function(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, T5, T6, T7, Value>(arg3: T3, into function: @escaping (T1, T2, T3, T4, T5, T6, T7) -> Value) -> (T1, T2, T4, T5, T6, T7) -> Value {
    { arg1, arg2, arg4, arg5, arg6, arg7 in
        function(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, T5, T6, T7, Value>(arg4: T4, into function: @escaping (T1, T2, T3, T4, T5, T6, T7) -> Value) -> (T1, T2, T3, T5, T6, T7) -> Value {
    { arg1, arg2, arg3, arg5, arg6, arg7 in
        function(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, T5, T6, T7, Value>(arg5: T5, into function: @escaping (T1, T2, T3, T4, T5, T6, T7) -> Value) -> (T1, T2, T3, T4, T6, T7) -> Value {
    { arg1, arg2, arg3, arg4, arg6, arg7 in
        function(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, T5, T6, T7, Value>(arg6: T6, into function: @escaping (T1, T2, T3, T4, T5, T6, T7) -> Value) -> (T1, T2, T3, T4, T5, T7) -> Value {
    { arg1, arg2, arg3, arg4, arg5, arg7 in
        function(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, T5, T6, T7, Value>(arg7: T7, into function: @escaping (T1, T2, T3, T4, T5, T6, T7) -> Value) -> (T1, T2, T3, T4, T5, T6) -> Value {
    { arg1, arg2, arg3, arg4, arg5, arg6 in
        function(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, T5, T6, T7, T8, Value>(arg1: T1, into function: @escaping (T1, T2, T3, T4, T5, T6, T7, T8) -> Value) -> (T2, T3, T4, T5, T6, T7, T8) -> Value {
    { arg2, arg3, arg4, arg5, arg6, arg7, arg8 in
        function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, T5, T6, T7, T8, Value>(arg2: T2, into function: @escaping (T1, T2, T3, T4, T5, T6, T7, T8) -> Value) -> (T1, T3, T4, T5, T6, T7, T8) -> Value {
    { arg1, arg3, arg4, arg5, arg6, arg7, arg8 in
        function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, T5, T6, T7, T8, Value>(arg3: T3, into function: @escaping (T1, T2, T3, T4, T5, T6, T7, T8) -> Value) -> (T1, T2, T4, T5, T6, T7, T8) -> Value {
    { arg1, arg2, arg4, arg5, arg6, arg7, arg8 in
        function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, T5, T6, T7, T8, Value>(arg4: T4, into function: @escaping (T1, T2, T3, T4, T5, T6, T7, T8) -> Value) -> (T1, T2, T3, T5, T6, T7, T8) -> Value {
    { arg1, arg2, arg3, arg5, arg6, arg7, arg8 in
        function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, T5, T6, T7, T8, Value>(arg5: T5, into function: @escaping (T1, T2, T3, T4, T5, T6, T7, T8) -> Value) -> (T1, T2, T3, T4, T6, T7, T8) -> Value {
    { arg1, arg2, arg3, arg4, arg6, arg7, arg8 in
        function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, T5, T6, T7, T8, Value>(arg6: T6, into function: @escaping (T1, T2, T3, T4, T5, T6, T7, T8) -> Value) -> (T1, T2, T3, T4, T5, T7, T8) -> Value {
    { arg1, arg2, arg3, arg4, arg5, arg7, arg8 in
        function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, T5, T6, T7, T8, Value>(arg7: T7, into function: @escaping (T1, T2, T3, T4, T5, T6, T7, T8) -> Value) -> (T1, T2, T3, T4, T5, T6, T8) -> Value {
    { arg1, arg2, arg3, arg4, arg5, arg6, arg8 in
        function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, T5, T6, T7, T8, Value>(arg8: T8, into function: @escaping (T1, T2, T3, T4, T5, T6, T7, T8) -> Value) -> (T1, T2, T3, T4, T5, T6, T7) -> Value {
    { arg1, arg2, arg3, arg4, arg5, arg6, arg7 in
        function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, T5, T6, T7, T8, T9, Value>(arg1: T1, into function: @escaping (T1, T2, T3, T4, T5, T6, T7, T8, T9) -> Value) -> (T2, T3, T4, T5, T6, T7, T8, T9) -> Value {
    { arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9 in
        function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, T5, T6, T7, T8, T9, Value>(arg2: T2, into function: @escaping (T1, T2, T3, T4, T5, T6, T7, T8, T9) -> Value) -> (T1, T3, T4, T5, T6, T7, T8, T9) -> Value {
    { arg1, arg3, arg4, arg5, arg6, arg7, arg8, arg9 in
        function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, T5, T6, T7, T8, T9, Value>(arg3: T3, into function: @escaping (T1, T2, T3, T4, T5, T6, T7, T8, T9) -> Value) -> (T1, T2, T4, T5, T6, T7, T8, T9) -> Value {
    { arg1, arg2, arg4, arg5, arg6, arg7, arg8, arg9 in
        function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, T5, T6, T7, T8, T9, Value>(arg4: T4, into function: @escaping (T1, T2, T3, T4, T5, T6, T7, T8, T9) -> Value) -> (T1, T2, T3, T5, T6, T7, T8, T9) -> Value {
    { arg1, arg2, arg3, arg5, arg6, arg7, arg8, arg9 in
        function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, T5, T6, T7, T8, T9, Value>(arg5: T5, into function: @escaping (T1, T2, T3, T4, T5, T6, T7, T8, T9) -> Value) -> (T1, T2, T3, T4, T6, T7, T8, T9) -> Value {
    { arg1, arg2, arg3, arg4, arg6, arg7, arg8, arg9 in
        function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, T5, T6, T7, T8, T9, Value>(arg6: T6, into function: @escaping (T1, T2, T3, T4, T5, T6, T7, T8, T9) -> Value) -> (T1, T2, T3, T4, T5, T7, T8, T9) -> Value {
    { arg1, arg2, arg3, arg4, arg5, arg7, arg8, arg9 in
        function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, T5, T6, T7, T8, T9, Value>(arg7: T7, into function: @escaping (T1, T2, T3, T4, T5, T6, T7, T8, T9) -> Value) -> (T1, T2, T3, T4, T5, T6, T8, T9) -> Value {
    { arg1, arg2, arg3, arg4, arg5, arg6, arg8, arg9 in
        function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, T5, T6, T7, T8, T9, Value>(arg8: T8, into function: @escaping (T1, T2, T3, T4, T5, T6, T7, T8, T9) -> Value) -> (T1, T2, T3, T4, T5, T6, T7, T9) -> Value {
    { arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg9 in
        function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    }
}

/// Binds an argument into the function such that it takes one less argument.
///
/// - Returns: A function that takes one less argument than `function`.
///     The value is bound into the specified argument position.
@_transparent
public func bind<T1, T2, T3, T4, T5, T6, T7, T8, T9, Value>(arg9: T9, into function: @escaping (T1, T2, T3, T4, T5, T6, T7, T8, T9) -> Value) -> (T1, T2, T3, T4, T5, T6, T7, T8) -> Value {
    { arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8 in
        function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    }
}
