//
//  Result.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 9/2/21.
//  Copyright © 2020-2022 Braden Scothern. All rights reserved.
//

extension Result {
    @inlinable
    public static func flatMap<Value0, Value1>(
        _ r0: Result<Value0, Failure>,
        _ r1: Result<Value1, Failure>,
        transform: (Value0, Value1) -> Self
    ) -> Self {
        r0.flatMap { r0 in
            r1.flatMap { r1 in
                transform(r0, r1)
            }
        }
    }

    @inlinable
    public static func flatMap<Value0, Value1, Value2>(
        _ r0: Result<Value0, Failure>,
        _ r1: Result<Value1, Failure>,
        _ r2: Result<Value2, Failure>,
        transform: (Value0, Value1, Value2) -> Self
    ) -> Self {
        r0.flatMap { r0 in
            r1.flatMap { r1 in
                r2.flatMap { r2 in
                    transform(r0, r1, r2)
                }
            }
        }
    }

    @inlinable
    public static func flatMap<Value0, Value1, Value2, Value3>(
        _ r0: Result<Value0, Failure>,
        _ r1: Result<Value1, Failure>,
        _ r2: Result<Value2, Failure>,
        _ r3: Result<Value3, Failure>,
        transform: (Value0, Value1, Value2, Value3) -> Self
    ) -> Self {
        r0.flatMap { r0 in
            r1.flatMap { r1 in
                r2.flatMap { r2 in
                    r3.flatMap { r3 in
                        transform(r0, r1, r2, r3)
                    }
                }
            }
        }
    }

    @inlinable
    public static func flatMap<Value0, Value1, Value2, Value3, Value4>(
        _ r0: Result<Value0, Failure>,
        _ r1: Result<Value1, Failure>,
        _ r2: Result<Value2, Failure>,
        _ r3: Result<Value3, Failure>,
        _ r4: Result<Value4, Failure>,
        transform: (Value0, Value1, Value2, Value3, Value4) -> Self
    ) -> Self {
        r0.flatMap { r0 in
            r1.flatMap { r1 in
                r2.flatMap { r2 in
                    r3.flatMap { r3 in
                        r4.flatMap { r4 in
                            transform(r0, r1, r2, r3, r4)
                        }
                    }
                }
            }
        }
    }
}

extension Result where Failure == Error {
    @inlinable
    @_disfavoredOverload
    public static func flatMap<Value0, Failure0, Value1, Failure1>(
        _ r0: Result<Value0, Failure0>,
        _ r1: Result<Value1, Failure1>,
        transform: (Value0, Value1) -> Self
    ) -> Self
    where Failure0: Error, Failure1: Error {
        do {
            let r0 = try r0.get()
            let r1 = try r1.get()
            return transform(r0, r1)
        } catch {
            return .failure(error)
        }
    }

    @inlinable
    @_disfavoredOverload
    public static func flatMap<Value0, Failure0, Value1, Failure1, Value2, Failure2>(
        _ r0: Result<Value0, Failure0>,
        _ r1: Result<Value1, Failure1>,
        _ r2: Result<Value2, Failure2>,
        transform: (Value0, Value1, Value2) -> Self
    ) -> Self {
        do {
            let r0 = try r0.get()
            let r1 = try r1.get()
            let r2 = try r2.get()
            return transform(r0, r1, r2)
        } catch {
            return .failure(error)
        }
    }

    @inlinable
    @_disfavoredOverload
    public static func flatMap<Value0, Failure0, Value1, Failure1, Value2, Failure2, Value3, Failure3>(
        _ r0: Result<Value0, Failure0>,
        _ r1: Result<Value1, Failure1>,
        _ r2: Result<Value2, Failure2>,
        _ r3: Result<Value3, Failure3>,
        transform: (Value0, Value1, Value2, Value3) -> Self
    ) -> Self {
        do {
            let r0 = try r0.get()
            let r1 = try r1.get()
            let r2 = try r2.get()
            let r3 = try r3.get()
            return transform(r0, r1, r2, r3)
        } catch {
            return .failure(error)
        }
    }

    @inlinable
    @_disfavoredOverload
    public static func flatMap<Value0, Failure0, Value1, Failure1, Value2, Failure2, Value3, Failure3, Value4, Failure4>(
        _ r0: Result<Value0, Failure0>,
        _ r1: Result<Value1, Failure1>,
        _ r2: Result<Value2, Failure2>,
        _ r3: Result<Value3, Failure3>,
        _ r4: Result<Value4, Failure4>,
        transform: (Value0, Value1, Value2, Value3, Value4) -> Self
    ) -> Self {
        do {
            let r0 = try r0.get()
            let r1 = try r1.get()
            let r2 = try r2.get()
            let r3 = try r3.get()
            let r4 = try r4.get()
            return transform(r0, r1, r2, r3, r4)
        } catch {
            return .failure(error)
        }
    }
}
