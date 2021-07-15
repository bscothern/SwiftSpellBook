//
//  SafeManagedBuffer.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 10/30/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

/// The `SafeManagedBuffer` type adding convinence and help working with a `ManagedBuffer` in a safe manner.
///
/// Generally `SafeManagedBuffer` and `ManagedBuffer` should be avoided.
/// They are almost always slower and less memory efficient than other data structures and types giving the same behavior.
///
/// # Custom Inits
///
/// Creating a custom init on a `SafeManagedBuffer` is not done the same way as in other types.
/// This is because `ManagedBuffer` has one `init` that is private and you create an instance via the factory function `create(minimumCapacity:makingHeaderWith:)`.
///
/// To bypass this restriction and create a more swifty interface on your types with a typical init you will need to follow this pattern:
/// 1) Create your type without any inits and have it inherit from `SafeManagedBuffer`.
/// 2) Create an extension, typeically named the same as the type you are creating with a leading underscore since it is a private implimentation detail.
///     Note that the access modifier on this protocol will define the maximum accessiblity of your init.
/// 3) Have this new protocol conform to `SafeManagedBufferProtocol` and constrain the `HeaderValue` and `Element` to match what they will be.
/// 4) Create an extension on your new protocol with your custom `init` and inside of it call another `init` that is available to you eventually calling an init on `SafeManagedBufferProtocol` (they are actually on`_SafeManagedBufferProtocol` which is an implimentation detail of `SafeManagedBufferProtocol`).
/// 5) Go back to your class and have it conform to your new protocol.
///
/// Here is a basic example of how you could copy an array out to an `SafeManagedBuffer` object in an init.
/// ```swift
/// public final class ExampleBuffer<Element>: SafeManagedBuffer<Void, Element>, _ExampleBuffer {}
///
/// public protocol _ExampleBuffer: SafeManagedBufferProtocol where HeaderValue == Void {}
///
/// extension _ExampleBuffer {
///     public init(elements: [Element]) {
///         self.init(
///             minimumCapacity: elements.count,
///             deinitStrategy: .minimumCapacity,
///             makingHeaderWith: { _ in Void() },
///             thenFinishInit: {
///                 $0.withUnsafeMutablePointerToElements { bufferElements in
///                     var offset = 0
///                     elements.forEach { element in
///                         bufferElements.advanced(by: offset).initialize(to: element)
///                         offset += 1
///                     }
///                 }
///             }
///         )
///     }
/// }
/// ```
public typealias SafeManagedBuffer<HeaderValue, Element> = _SafeManagedBuffer<HeaderValue, Element> & SafeManagedBufferProtocol

/// Describes the `SafeManagedBuffer` interface so it can be used during the initalization of subclasses.
///
/// - See: `SafeManagedBuffer` documentation for more information.
public protocol SafeManagedBufferProtocol: _SafeManagedBufferProtocol {
    /// A box around `HeaderValue` simplifying the use of the raw `Header` of the `ManagedBuffer` backing hte `SafeManagedBuffer` behavior.
    ///
    /// This is provided for you and should not be customized.
    associatedtype Header

    /// A custom value to put in your `SafeManagedBuffer.Header`.
    associatedtype HeaderValue

    /// The element type that the `SafeManagedBuffer` will contain.
    associatedtype Element

    #if swift(>=5.4)
    /// The actual number of elements that can be stored in this object.
    ///
    /// This header may be nontrivial to compute; it is usually a good idea to store this information in the "header" area when an instance is created.
    @available(OpenBSD, unavailable, message: "malloc_size is unavailable.")
    var capacity: Int { get }
    #else

    /// The actual number of elements that can be stored in this object.
    ///
    /// This header may be nontrivial to compute; it is usually a good idea to store this information in the "header" area when an instance is created.
    var capacity: Int { get }
    #endif

    /// Call `body` with an `UnsafeMutablePointer` to the stored `Header`.
    ///
    /// - Note:
    ///     This pointer is valid only for the duration of the call to `body`.
    func withUnsafeMutablePointerToHeader<R>(_ body: (UnsafeMutablePointer<Header>) throws -> R) rethrows -> R

    /// Call `body` with an `UnsafeMutablePointer` to the `Element` storage.
    ///
    /// - Note:
    ///     This pointer is valid only for the duration of the call to `body`.
    func withUnsafeMutablePointerToElements<R>(_ body: (UnsafeMutablePointer<Element>) throws -> R) rethrows -> R

    /// Call `body` with `UnsafeMutablePointer`s to the stored `Header` and raw `Element` storage.
    ///
    /// - Note:
    ///     These pointers are valid only for the duration of the call to `body`.
    func withUnsafeMutablePointers<R>(_ body: (UnsafeMutablePointer<Header>, UnsafeMutablePointer<Element>) throws -> R) rethrows -> R
}

/// Describes the behavior that a `SafeManagedBuffer` should use for deinitialization of its buffer during its deinit.
public enum SafeManagedBufferDeinitStrategy {
    /// Deinitialize the header's `count` elements at the specified element offset in the buffer.
    case count(fromOffset: Int = 0)

    /// Deinitialize only the memory that was requested.
    ///
    /// This means you shouldn't access memory past the minimum capacity requested when allocated even if the buffer is larger.
    case minimumCapacity

    /// Deinitialize the entire buffer.
    ///
    /// This should only be used over `.minimumCapacity` if you plan on using the entire buffer which may be larger than the minimum size requested.
    case fullCapacity

    /// Defines chunks of memory that should be deinitialized.
    ///
    /// - Important:
    ///     For convenience the `DeinitChunks` value is a class so it can easily be mutated with new offsets and counts without needing to unwrap and rewrap it.
    case chunks(DeinitChunks = .init())

    /// A helper type for `SafeManagedBufferDeinitStrategy.chunks(_:)` that describes the offsets and size of chunks that should be deinitialized in a `SafeManagedBuffer` during `deinit`.
    public final class DeinitChunks {
        /// A chunk of memory that should be cleaned up.
        public struct Value {
            /// The offset to the chunk.
            public let offset: Offset
            /// How many elements should be cleaned up in this chunk.
            public let count: Int

            /// Creates a `DeinitChunks.Value`.
            ///
            /// - Parameters:
            ///   - offset: The offset ot the chunk.
            ///   - count: How many elements should be cleaned up in this chunk.
            @inlinable
            public init(offset: Offset, count: Int) {
                self.offset = offset
                self.count = count
            }
        }

        /// Describes the offset behavior and distance.
        public enum Offset {
            /// The offset is from the start of the buffer.
            case fromStart(offset: Int)
            /// The offset is from the end of the last chunk.
            ///
            /// - Important:
            ///     If no previous chunk exists then this behaves as `fromStart(offset:)`.
            case fromLast(offset: Int)
        }

        /// The current chunks to be deinitialized on `SafeManagedBuffer` deinit.
        public var values: [Value] = []

        /// Creates an empty `DeinitChunks`.
        @inlinable
        public init() {}
    }
}

open class _SafeManagedBuffer<HeaderValue, Element>: ManagedBuffer<_SafeManagedBuffer<HeaderValue, Element>.Header, Element> {
    @dynamicMemberLookup
    public struct Header: _ManagedBufferHeader {
        public let minimumCapacity: Int
        public var deinitStrategy: SafeManagedBufferDeinitStrategy
        public var count: Int = 0
        public var value: HeaderValue

        @inlinable
        public init(minimumCapacity: Int, deinitStrategy: SafeManagedBufferDeinitStrategy, value: HeaderValue) {
            self.minimumCapacity = minimumCapacity
            self.deinitStrategy = deinitStrategy
            self.value = value
        }

        @inlinable
        public subscript<T>(dynamicMember dynamicMember: KeyPath<HeaderValue, T>) -> T {
            value[keyPath: dynamicMember]
        }

        @inlinable
        public subscript<T>(dynamicMember dynamicMember: WritableKeyPath<HeaderValue, T>) -> T {
            get { value[keyPath: dynamicMember] }
            set { value[keyPath: dynamicMember] = newValue }
            _modify { yield &value[keyPath: dynamicMember] }
        }
    }

    @inlinable
    deinit {
        _deinit()
    }

    // Pulled out of the normal deinit in order to get proper code coerage...
    @usableFromInline
    func _deinit() {
        withUnsafeMutablePointers { header, elements in
            switch header.pointee.deinitStrategy {
            case let .count(offset):
                elements
                    .advanced(by: offset)
                    .deinitialize(count: header.pointee.count)
            case .minimumCapacity:
                elements
                    .deinitialize(count: header.pointee.minimumCapacity)
            case .fullCapacity:
                elements
                    .deinitialize(count: capacity)
            case let .chunks(chunks):
                var previousOffsetDistance: Int = 0
                for chunk in chunks.values {
                    switch chunk.offset {
                    case let .fromStart(offsetDistance):
                        elements
                            .advanced(by: offsetDistance)
                            .deinitialize(count: chunk.count)
                        previousOffsetDistance = offsetDistance + chunk.count
                    case let .fromLast(offsetDistance):
                        elements
                            .advanced(by: previousOffsetDistance)
                            .advanced(by: offsetDistance)
                            .deinitialize(count: chunk.count)
                        previousOffsetDistance += offsetDistance + chunk.count
                    }
                }
            }
        }
    }
}

public protocol _ManagedBufferHeader {
    associatedtype HeaderValue

    var minimumCapacity: Int { get }
    var deinitStrategy: SafeManagedBufferDeinitStrategy { get set }
    var count: Int { get set }
    var value: HeaderValue { get set }

    init(minimumCapacity: Int, deinitStrategy: SafeManagedBufferDeinitStrategy, value: HeaderValue)
}

public protocol _SafeManagedBufferProtocol where Header.HeaderValue == HeaderValue {
    associatedtype Header: _ManagedBufferHeader
    associatedtype HeaderValue
    associatedtype Element

    init(
        minimumCapacity: Int,
        deinitStrategy: SafeManagedBufferDeinitStrategy,
        makingHeaderWith: (ManagedBuffer<Header, Element>) -> HeaderValue
    )

    static func create(
        minimumCapacity: Int,
        makingHeaderWith factory: (ManagedBuffer<Header, Element>) throws -> Header
    ) rethrows -> ManagedBuffer<Header, Element>
}

extension _SafeManagedBufferProtocol {
    @inlinable
    public init(
        minimumCapacity: Int,
        deinitStrategy: SafeManagedBufferDeinitStrategy = .count(fromOffset: 0),
        makingHeaderWith: (ManagedBuffer<Header, Element>) -> HeaderValue,
        thenFinishInit finishInit: (Self) -> Void
    ) {
        self = Self.create(minimumCapacity: minimumCapacity) { managedBuffer in
            .init(
                minimumCapacity: minimumCapacity,
                deinitStrategy: deinitStrategy,
                value: makingHeaderWith(managedBuffer)
            )
        } as! Self
        finishInit(self)
    }

    @inlinable
    public init(
        minimumCapacity: Int,
        deinitStrategy: SafeManagedBufferDeinitStrategy = .count(fromOffset: 0),
        makingHeaderWith: (ManagedBuffer<Header, Element>) -> HeaderValue
    ) {
        self.init(
            minimumCapacity: minimumCapacity,
            deinitStrategy: deinitStrategy,
            makingHeaderWith: makingHeaderWith,
            thenFinishInit: { _ in }
        )
    }

    @inlinable
    public init(
        minimumCapacity: Int,
        deinitStrategy: SafeManagedBufferDeinitStrategy = .count(fromOffset: 0)
    ) where HeaderValue == Void {
        self.init(
            minimumCapacity: minimumCapacity,
            deinitStrategy: deinitStrategy,
            makingHeaderWith: { _ in }
        )
    }

    @inlinable
    public init(
        minimumCapacity: Int,
        deinitStrategy: SafeManagedBufferDeinitStrategy = .count(fromOffset: 0),
        thenFinishInit finishInit: (Self) -> Void
    )  where HeaderValue == Void {
        self.init(
            minimumCapacity: minimumCapacity,
            deinitStrategy: deinitStrategy,
            makingHeaderWith: { _ in },
            thenFinishInit: finishInit
        )
    }
}
