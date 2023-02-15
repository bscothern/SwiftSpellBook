//
//  Sequence+ForEach.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/18/20.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

extension Sequence {
    /// Calls a function on each member of the sequence.
    ///
    /// This is generally helpful when you have a function on the `Element` type that you want to call on each member of your sequence.
    /// The following example shows typical usage where this is most helpful.
    /// ```swift
    /// struct Foo {
    ///     func doSomeWork() {
    ///         // Do some work
    ///     }
    /// }
    ///
    /// let array: [Foo] = [Foo(), Foo()]
    /// array.forEach(execute: Foo.doSomeWork)
    /// ```
    ///
    /// - Parameter function: A function that takes an `Element` and creates another function that should be executed.
    @inlinable
    public func forEach(execute function: (Element) -> () -> Void) {
        forEach { element in
            function(element)()
        }
    }
}
