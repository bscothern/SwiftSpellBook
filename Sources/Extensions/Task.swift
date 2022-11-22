//
//  Task.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 4/7/22.
//  Copyright © 2020-2022 Braden Scothern. All rights reserved.
//

#if swift(>=5.5) && canImport(Foundation)
import Foundation

/// TODO: Figure out the name of free functions so you can do stuff like this instead of using all of these functions
/// ```swift
/// let value = waitForAsync {
///     await foo()
/// }
/// ```
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Task {
    /// An object that contains the state to safely implement `waitUntilFinished()`.
    @usableFromInline
    struct WaitUntilFinishedContext<Success, Failure>: @unchecked Sendable where Failure: Error {
        @usableFromInline
        struct Value {
            @usableFromInline
            let semaphore: DispatchSemaphore = .init(value: 0)

            @usableFromInline
            var result: Result<Success, Failure>?

            @usableFromInline
            init() {}
        }

        /// The pointer which lets things work because it is immutable and this struct needs to be immutable.
        ///
        /// In this case it is ok to use the indirection to "break" Sendable checking because we know it is only used in the 2 contexts and it is used safely.
        @usableFromInline
        let _pointer: UnsafeMutablePointer<Value> = .allocate(capacity: 1)

        /// Creates a `WaitUntilFinishedContext`.
        @usableFromInline
        init() {
            _pointer.initialize(to: .init())
        }
        
        /// Recieve a result and signal to wake up the waiting context.
        ///
        /// - Parameter result: The value of the `Task` execution.
        @usableFromInline
        func recieve(result: Result<Success, Failure>) {
            _pointer.pointee.result = result
            _pointer.pointee.semaphore.signal()
        }

        /// Wait until a value has been recieved from the `Task` then consume this context.
        ///
        /// - Important: After this is called the context is not safe to use again.
        ///
        /// - Returns: The result of the `Task` execution.
        @usableFromInline
        func waitAndConsume() -> Result<Success, Failure> {
            _pointer.pointee.semaphore.wait()
            defer { _pointer.deallocate() }
            return _pointer.move().result!
        }
    }

    /// Creates the task the context and task that will receive the value of the current Task.
    @usableFromInline
    func _waitUntilFinished() -> Result<Success, Failure> {
        let context = WaitUntilFinishedContext<Success, Failure>()
        Task<Void, Never> {
            context.recieve(result: await self.result)
        }
        return context.waitAndConsume()
    }

    /// Waits for the task to finish execution and then returns its value.
    ///
    /// This is mostly useful in non-async contexts when you need to call an async function and wait for its return as if it were a synchronous function.
    /// This is most often done like so:
    /// ```swift
    /// let value = Task {
    ///     await someAsyncFunction()
    /// }.waitUntilFinished()
    /// ```
    ///
    /// - Returns: The value of the current `Task`.
    @_transparent
    public func waitUntilFinished() -> Success where Failure == Never {
        try! _waitUntilFinished().get()
    }

    /// Waits for the task to finish execution and then returns its value.
    ///
    /// This is mostly useful in non-async contexts when you need to call an async function and wait for its return as if it were a synchronous function.
    /// This is most often done like so:
    /// ```swift
    /// let value = try Task {
    ///     try await someAsyncFunction()
    /// }.waitUntilFinished()
    /// ```
    ///
    /// - Throws: Whatever error was raised by the task.
    /// - Returns: The value of the current `Task`.
    @_transparent
    public func waitUntilFinished() throws -> Success {
        try _waitUntilFinished().get()
    }

    /// Waits for the task to finish execution and then returns its value.
    ///
    /// This is mostly useful in non-async contexts when you need to call an async function and wait for its return as if it were a synchronous function.
    /// This is most often done like so:
    /// ```swift
    /// let value: Result = Task {
    ///     try await someAsyncFunction()
    /// }.waitUntilFinished()
    /// ```
    ///
    /// - Returns: The value of the current `Task`.
    @_disfavoredOverload
    @_transparent
    public func waitUntilFinished() -> Result<Success, Failure> {
        _waitUntilFinished()
    }
}

#endif
 
