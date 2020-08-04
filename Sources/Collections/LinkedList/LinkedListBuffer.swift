//
//  LinkedListBuffer.swift
//  ThingsMissingFromSwift
//
//  Created by Braden Scothern on 7/15/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

@usableFromInline
final class LinkedListBuffer<Element, Node> where Node: LinkedListNode, Node.Element == Element {
    @usableFromInline
    var head: UnsafeMutablePointer<Node>?
    
    @usableFromInline
    var tail: UnsafeMutablePointer<Node>?
    
    @usableFromInline
    var count: Int = 0
    
    @usableFromInline
    init() {}
    
    @usableFromInline
    init(head: UnsafeMutablePointer<Node>, tail: UnsafeMutablePointer<Node>, count: Int) {
        self.head = head
        self.tail = tail
        self.count = count
    }
    
    @usableFromInline
    deinit {
        guard let head = head else { return }
        head.pointee.destoryNodes()
        head.deinitialize(count: 1)
        head.deallocate()
    }
}

extension LinkedListBuffer {
    @usableFromInline
    func createCopy() -> LinkedListBuffer<Element, Node> {
        guard let copy = head?.pointee.createCopy() else {
            return self
        }
        return .init(head: copy.head, tail: copy.tail, count: count)
    }
}

extension LinkedListBuffer: Collection {
    @usableFromInline
    typealias Element = Element

    @usableFromInline
    struct Index: Comparable, ExpressibleByIntegerLiteral {
        @usableFromInline
        enum Offset: Comparable {
            case value(Int)
            case end
            
            @usableFromInline
            var unwrapValue: Int {
                guard case let .value(value) = self else {
                    fatalError("\(#function) requires that \(Self.self) to be a .value")
                }
                return value
            }

            @usableFromInline
            static func == (lhs: Self, rhs: Self) -> Bool {
                switch (lhs, rhs) {
                case let (.value(lhs), .value(rhs)):
                    return lhs == rhs
                case (.end, .end):
                    return true
                default:
                    return false
                }
            }
            
            @usableFromInline
            static func < (lhs: Self, rhs: Self) -> Bool {
                switch (lhs, rhs) {
                case let (.value(lhs), .value(rhs)):
                    return lhs < rhs
                case (.end, .end):
                    return false
                case (.value, .end):
                    return true
                case (.end, .value):
                    return false
                }
            }
        }

        @usableFromInline
        let node: UnsafeMutablePointer<Node>?
        
        @usableFromInline
        let offset: Offset

        @usableFromInline
        init(node: UnsafeMutablePointer<Node>?, offset: Offset) {
            self.node = node
            self.offset = offset
        }
        
        @usableFromInline
        init(integerLiteral value: Int) {
            self.node = nil
            self.offset = .value(value)
        }

        @usableFromInline
        static func < (lhs: Self, rhs: Self) -> Bool {
            print("< --\n\t\(lhs)\n\t\(rhs)\n")
            let endIndex = Self(node: nil, offset: .end)
            if lhs == endIndex {
                print("false")
                return false
            } else if rhs == endIndex {
                print("true")
                return true
            } else {
                print("false")
                return lhs.offset < rhs.offset
            }
        }
    }

    @usableFromInline
    var startIndex: Index { Index(node: head, offset: isEmpty ? .end : .value(0)) }

    @usableFromInline
    var endIndex: Index { Index(node: nil, offset: .end) }
    
    @usableFromInline
    var last: Element? { tail?.pointee.element }
    
    @usableFromInline
    var isEmpty: Bool { count == 0 }

    @usableFromInline
    subscript(position: Index) -> Element {
        guard position.offset != .end else {
            fatalError("Invalid Index when accessing LinkedList")
        }
        let offsetValue = position.offset.unwrapValue
        if let node = position.node {
            return node.pointee.element
        } else if offsetValue >= 0 && offsetValue < count {
            var node = head
            for _ in 0 ..< offsetValue {
                node = node?.pointee.next
            }
            return node!.pointee.element
        } else {
            fatalError("Invalid Index when accessing LinkedList")
        }
    }

    @usableFromInline
    func index(after i: Index) -> Index {
        guard i.offset != .end else { return endIndex }
        let offsetPlus1 = i.offset.unwrapValue + 1
        guard offsetPlus1 < count else { return endIndex }

        let next: UnsafeMutablePointer<Node>? = i.node?.pointee.next ?? {
            var node = startIndex.node
            for _ in 0..<offsetPlus1 {
                node = node?.pointee.next
            }
            return node
        }()
        return Index(node: next, offset: .value(offsetPlus1))
    }
}

extension LinkedListBuffer {
    @usableFromInline
    @discardableResult
    func removeFirst() -> Element {
        fatalError()
    }
    
    @usableFromInline
    func popFirst() -> Element? {
        guard let first = head else {
            return nil
        }
        defer {
            first.deinitialize(count: 1)
            first.deallocate()
        }
        head = first.pointee.next
        return first.pointee.element
    }
    
    @usableFromInline
    @discardableResult
    func removeLast() -> Element {
        fatalError()
    }
}

extension LinkedListBuffer where Node == SingleLinkedListNode<Element> {
    @usableFromInline
    func popLast() -> Element? {
        guard let last = tail else {
            return nil
        }
        defer {
            last.deinitialize(count: 1)
            last.deallocate()
        }
        return last.pointee.element
    }
}

//extension LinkedListBuffer: BidirectionalCollection where Node == DoubleLinkedListNode<Element> {
//    @usableFromInline
//    func index(before i: Index) -> Index {
//        guard i != endIndex else {
//            return Index(node: tail, offset: count - 1)
//        }
//        return Index(node: i.node?.pointee.previous, offset: i.offset - 1)
//    }
//}
