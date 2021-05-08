//
//  SafeManagedBuffer.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 10/30/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

open class _SafeManagedBuffer<HeaderValue, Element>: ManagedBuffer<_SafeManagedBuffer<HeaderValue, Element>.Header, Element> {
    @dynamicMemberLookup
    public struct Header: _ManagedBufferHeader {
        public let minimumCapacity: Int
        public let deinitStrategy: SafeManagedBufferDeinitStrategy
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
        }
    }

    @inlinable
    deinit {
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

public enum SafeManagedBufferDeinitStrategy {
    case count(fromOffset: Int = 0)
    case minimumCapacity
    case fullCapacity
    case chunks(DeinitChunks = .init())

    public final class DeinitChunks {
        public struct Value {
            public let offset: Offset
            public let count: Int

            @inlinable
            public init(offset: Offset, count: Int) {
                self.offset = offset
                self.count = count
            }
        }

        public enum Offset {
            case fromStart(offset: Int)
            case fromLast(offset: Int)
        }

        public var values: [Value] = []

        @inlinable
        public init() {}
    }
}

public protocol _ManagedBufferHeader {
    associatedtype HeaderValue
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
        makingHeaderWith: (ManagedBuffer<Header, Element>) -> HeaderValue
    ) {
        self = Self.create(minimumCapacity: minimumCapacity) { managedBuffer in
            .init(
                minimumCapacity: minimumCapacity,
                deinitStrategy: deinitStrategy,
                value: makingHeaderWith(managedBuffer)
            )
        } as! Self
    }

    @inlinable
    public init(
        minimumCapacity: Int,
        deinitStrategy: SafeManagedBufferDeinitStrategy = .count(fromOffset: 0)
    ) where HeaderValue == Void {
        self.init(minimumCapacity: minimumCapacity, deinitStrategy: deinitStrategy) { _ in }
    }

    @inlinable
    public init(
        minimumCapacity: Int,
        deinitStrategy: SafeManagedBufferDeinitStrategy = .count(fromOffset: 0),
        makingHeaderWith: (ManagedBuffer<Header, Element>) -> HeaderValue,
        thenFinishInit finishInit: (Self) -> Void
    ) {
        self.init(minimumCapacity: minimumCapacity, deinitStrategy: deinitStrategy, makingHeaderWith: makingHeaderWith)
        finishInit(self)
    }

    @inlinable
    public init(
        minimumCapacity: Int,
        deinitStrategy: SafeManagedBufferDeinitStrategy = .count(fromOffset: 0),
        thenFinishInit finishInit: (Self) -> Void
    )  where HeaderValue == Void {
        self.init(minimumCapacity: minimumCapacity, deinitStrategy: deinitStrategy, makingHeaderWith: { _ in }, thenFinishInit: finishInit)
    }
}

public protocol SafeManagedBufferProtocol: _SafeManagedBufferProtocol {
    associatedtype Header
    associatedtype HeaderValue
    associatedtype Element
    func withUnsafeMutablePointerToHeader<R>(_ body: (UnsafeMutablePointer<Header>) throws -> R) rethrows -> R
    func withUnsafeMutablePointerToElements<R>(_ body: (UnsafeMutablePointer<Element>) throws -> R) rethrows -> R
    func withUnsafeMutablePointers<R>(_ body: (UnsafeMutablePointer<Header>, UnsafeMutablePointer<Element>) throws -> R) rethrows -> R
}

public typealias SafeManagedBuffer<HeaderValue, Element> = _SafeManagedBuffer<HeaderValue, Element> & SafeManagedBufferProtocol
