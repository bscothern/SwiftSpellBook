//
//  SafeManagedBuffer.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 10/30/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

public final class SafeManagedBuffer<HeaderValue, Element>:  ManagedBuffer<SafeManagedBuffer<HeaderValue, Element>.Header, Element>, _SafeManagedBuffer {
    @dynamicMemberLookup
    public struct Header: ManagedBufferHeader {
        public let minimumCapacity: Int
        public let deinitStrategy: SafeManagedBufferDeinitStrategy
        public var count: Int = 0
        public var value: HeaderValue

        @usableFromInline
        init(minimumCapacity: Int, deinitStrategy: SafeManagedBufferDeinitStrategy, value: HeaderValue) {
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
            case let .offsets(offsets):
                var previousOffsetDistance: Int = 0
                for offset in offsets.values {
                    switch offset.offsetType {
                    case let .fromStart(offsetDistance):
                        elements
                            .advanced(by: offsetDistance)
                            .deinitialize(count: offset.count)
                        previousOffsetDistance = offsetDistance + offset.count
                    case let .fromLast(offsetDistance):
                        elements
                            .advanced(by: previousOffsetDistance)
                            .advanced(by: offsetDistance)
                            .deinitialize(count: offset.count)
                        previousOffsetDistance += offsetDistance + offset.count
                        break
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
    case offsets(DeinitOffsets = .init())
    
    public final class DeinitOffsets {
        public struct Value {
            public let offsetType: DeinitOffsetType
            public let count: Int
            
            @inlinable
            public init(_ offsetType: DeinitOffsetType, count: Int) {
                self.offsetType = offsetType
                self.count = count
            }
        }
        
        public enum DeinitOffsetType {
            case fromStart(offset: Int)
            case fromLast(offset: Int)
        }
        
        public var values: [Value] = []
        
        @inlinable
        public init() {}
    }
}

protocol ManagedBufferHeader {
    associatedtype HeaderValue
    init(minimumCapacity: Int, deinitStrategy: SafeManagedBufferDeinitStrategy, value: HeaderValue)
}

protocol _SafeManagedBuffer where Header.HeaderValue == HeaderValue {
    associatedtype Header: ManagedBufferHeader
    associatedtype HeaderValue
    associatedtype Element
    init(minimumCapacity: Int, deinitStrategy: SafeManagedBufferDeinitStrategy, makingHeaderWith: (ManagedBuffer<Header, Element>) -> HeaderValue)
    static func create(minimumCapacity: Int, makingHeaderWith factory: (ManagedBuffer<Header, Element>) throws -> Header) rethrows -> ManagedBuffer<Header, Element>
}

extension _SafeManagedBuffer  {
    @inlinable
    public init(minimumCapacity: Int, deinitStrategy: SafeManagedBufferDeinitStrategy = .count(), makingHeaderWith: (ManagedBuffer<Header, Element>) -> HeaderValue) {
        self = Self.create(minimumCapacity: minimumCapacity, makingHeaderWith: { buffer in
            return .init(minimumCapacity: minimumCapacity, deinitStrategy: deinitStrategy, value: makingHeaderWith(buffer))
        }) as! Self
    }
    
    @inlinable
    public init(minimumCapacity: Int, deinitStrategy: SafeManagedBufferDeinitStrategy = .count()) where HeaderValue == Void {
        self.init(minimumCapacity: minimumCapacity, deinitStrategy: deinitStrategy, makingHeaderWith: { _ in })
    }
}
