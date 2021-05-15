//
//  SafeManagedBufferTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 5/7/21.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import SwiftMemoryManagementSpellBook
import XCTest

final class SafeManagedBufferTests: XCTestCase {
    final class DidDeinit {
        let value: String
        let onDeinit: () -> Void

        var a: String { value }

        var b: Int = 0

        init(value: String, onDeinit: @escaping () -> Void) {
            self.value = value
            self.onDeinit = onDeinit
        }

        deinit {
            onDeinit()
        }
    }

    final class CustomSafeManagedBufferCount: SafeManagedBuffer<DidDeinit, Int>, _CustomSafeManagedBufferCount {}
    final class CustomSafeManagedBufferMinimum: SafeManagedBuffer<DidDeinit, Int>, _CustomSafeManagedBufferMinimum {}
    final class CustomSafeManagedBufferFullCapacity: SafeManagedBuffer<DidDeinit, Int>, _CustomSafeManagedBufferFullCapacity {}
    final class CustomSafeManagedBufferChunks: SafeManagedBuffer<DidDeinit, Int>, _CustomSafeManagedBufferChunks {}
    final class InitTesterSafeManagedBuffer: SafeManagedBuffer<Void, Int>, _InitTesterSafeManagedBuffer {}

    func testCount() {
        var deinitCount = 0
        do {
            let headerValue = String(Int.random(in: .min ... .max))
            let didDeinit = DidDeinit(value: headerValue) {
                deinitCount += 1
            }
            let bufferPointer: UnsafeMutablePointer<CustomSafeManagedBufferCount> = .allocate(capacity: 1)
            defer {
                bufferPointer.deinitialize(count: 1)
                bufferPointer.deallocate()
            }
            bufferPointer.initialize(to: CustomSafeManagedBufferCount(header: didDeinit, values: [3, 2, 1]))

            XCTAssertEqual(bufferPointer.pointee.header.value.value, headerValue)
            XCTAssertEqual(bufferPointer.pointee.header.a, headerValue)
            bufferPointer.pointee.header.b = 1
            bufferPointer.pointee.header.b += 1
            XCTAssertEqual(bufferPointer.pointee.header.b, 2)

            bufferPointer.pointee.withUnsafeMutablePointerToElements { elements in
                // Ensure that the offset functionality works
                XCTAssertEqual(elements[1], 3)
                XCTAssertEqual(elements[2], 2)
                XCTAssertEqual(elements[3], 1)
            }
        }
        XCTAssertEqual(deinitCount, 1)
    }

    func testMinimum() {
        var deinitCount = 0
        do {
            let headerValue = String(Int.random(in: .min ... .max))
            let didDeinit = DidDeinit(value: headerValue) {
                deinitCount += 1
            }
            let bufferPointer: UnsafeMutablePointer<CustomSafeManagedBufferMinimum> = .allocate(capacity: 1)
            defer {
                bufferPointer.deinitialize(count: 1)
                bufferPointer.deallocate()
            }
            bufferPointer.initialize(to: CustomSafeManagedBufferMinimum(header: didDeinit, values: [10, 11, 12]))

            XCTAssertEqual(bufferPointer.pointee.header.value.value, headerValue)
            XCTAssertEqual(bufferPointer.pointee.header.a, headerValue)
            bufferPointer.pointee.header.b = 1
            bufferPointer.pointee.header.b += 1
            XCTAssertEqual(bufferPointer.pointee.header.b, 2)

            bufferPointer.pointee.withUnsafeMutablePointerToElements { elements in
                XCTAssertEqual(elements[0], 10)
                XCTAssertEqual(elements[1], 11)
                XCTAssertEqual(elements[2], 12)
            }
        }
        XCTAssertEqual(deinitCount, 1)
    }

    func testFullCapacity() {
        var deinitCount = 0
        do {
            let headerValue = String(Int.random(in: .min ... .max))
            let didDeinit = DidDeinit(value: headerValue) {
                deinitCount += 1
            }
            let bufferPointer: UnsafeMutablePointer<CustomSafeManagedBufferFullCapacity> = .allocate(capacity: 1)
            defer {
                bufferPointer.deinitialize(count: 1)
                bufferPointer.deallocate()
            }
            let scale = Int.random(in: 1_000...10_000)
            bufferPointer.initialize(to: CustomSafeManagedBufferFullCapacity(header: didDeinit, scale: scale))

            XCTAssertEqual(bufferPointer.pointee.header.value.value, headerValue)
            XCTAssertEqual(bufferPointer.pointee.header.a, headerValue)
            bufferPointer.pointee.header.b = 1
            bufferPointer.pointee.header.b += 1
            XCTAssertEqual(bufferPointer.pointee.header.b, 2)

            let capacity = bufferPointer.pointee.capacity
            bufferPointer.pointee.withUnsafeMutablePointerToElements { elements in
                for i in 0..<capacity {
                    XCTAssertEqual(elements[i], (i + 1) * scale)
                }
            }
        }
        XCTAssertEqual(deinitCount, 1)
    }

    func testChunks() {
        var deinitCount = 0
        do {
            let headerValue = String(Int.random(in: .min ... .max))
            let didDeinit = DidDeinit(value: headerValue) {
                deinitCount += 1
            }
            let bufferPointer: UnsafeMutablePointer<CustomSafeManagedBufferChunks> = .allocate(capacity: 1)
            defer {
                bufferPointer.deinitialize(count: 1)
                bufferPointer.deallocate()
            }
            bufferPointer.initialize(to: CustomSafeManagedBufferChunks(header: didDeinit, values: [42, 43, 44]))

            XCTAssertEqual(bufferPointer.pointee.header.value.value, headerValue)
            XCTAssertEqual(bufferPointer.pointee.header.a, headerValue)
            bufferPointer.pointee.header.b = 1
            bufferPointer.pointee.header.b += 1
            XCTAssertEqual(bufferPointer.pointee.header.b, 2)

            bufferPointer.pointee.withUnsafeMutablePointers { header, elements in
                XCTAssertEqual(header.pointee.count, 3)
                XCTAssertEqual(elements[1], 42)
                XCTAssertEqual(elements[3], 43)
                XCTAssertEqual(elements[5], 44)
            }
        }
        XCTAssertEqual(deinitCount, 1)
    }

    func testInits() {
        let buffers = [
            InitTesterSafeManagedBuffer(_1: Void()),
            InitTesterSafeManagedBuffer(_2: Void()),
            InitTesterSafeManagedBuffer(_3: Void()),
            InitTesterSafeManagedBuffer(_4: Void()),
        ]

        for index in buffers.indices {
            var buffer: InitTesterSafeManagedBuffer { buffers[index] }
            buffer.header.count = 1
            buffer.withUnsafeMutablePointerToElements { elements in
                elements.initialize(to: Int(index))
            }
        }

        for index in buffers.indices {
            var buffer: InitTesterSafeManagedBuffer { buffers[index] }
            buffer.withUnsafeMutablePointerToElements { elements in
                XCTAssertEqual(elements.pointee, Int(index))
            }
        }
    }
}

// MARK: - SafeManagedBuffer subclass inits
protocol _CustomSafeManagedBufferCount: SafeManagedBufferProtocol where HeaderValue == SafeManagedBufferTests.DidDeinit, Element == Int {}
extension _CustomSafeManagedBufferCount {
    init(header: SafeManagedBufferTests.DidDeinit, values: [Int]) {
        self.init(
            minimumCapacity: values.count + 1,
            deinitStrategy: .count(fromOffset: 1),
            makingHeaderWith: { _ in header },
            thenFinishInit: {
                $0.withUnsafeMutablePointers { header, buffer in
                    header.pointee.count = values.count

                    var offset = 1
                    values.forEach { value in
                        buffer.advanced(by: offset).initialize(to: value)
                        offset += 1
                    }
                }
            }
        )
    }
}

protocol _CustomSafeManagedBufferMinimum: SafeManagedBufferProtocol where HeaderValue == SafeManagedBufferTests.DidDeinit, Element == Int {}
extension _CustomSafeManagedBufferMinimum {
    init(header: SafeManagedBufferTests.DidDeinit, values: [Int]) {
        self.init(
            minimumCapacity: values.count,
            deinitStrategy: .minimumCapacity,
            makingHeaderWith: { _ in header },
            thenFinishInit: {
                $0.withUnsafeMutablePointerToElements { buffer in
                    var offset = 0
                    values.forEach { value in
                        buffer.advanced(by: offset).initialize(to: value)
                        offset += 1
                    }
                }
            }
        )
    }
}

protocol _CustomSafeManagedBufferFullCapacity: SafeManagedBufferProtocol where HeaderValue == SafeManagedBufferTests.DidDeinit, Element == Int {}
extension _CustomSafeManagedBufferFullCapacity {
    init(header: SafeManagedBufferTests.DidDeinit, scale: Int) {
        self.init(
            minimumCapacity: 42,
            deinitStrategy: .fullCapacity,
            makingHeaderWith: { _ in header },
            thenFinishInit: { buffer in
                buffer.withUnsafeMutablePointerToElements { elements in
                    for i in 0..<buffer.capacity {
                        elements.advanced(by: i).initialize(to: (i + 1) * scale)
                    }
                }
            }
        )
    }
}

protocol _CustomSafeManagedBufferChunks: SafeManagedBufferProtocol where HeaderValue == SafeManagedBufferTests.DidDeinit, Element == Int {}
extension _CustomSafeManagedBufferChunks {
    init(header: SafeManagedBufferTests.DidDeinit, values: [Int]) {
        let chunks = SafeManagedBufferDeinitStrategy.DeinitChunks()
        chunks.values.append(.init(offset: .fromStart(offset: 1), count: 1))
        chunks.values.append(
            contentsOf: Array(
                repeating: .init(offset: .fromLast(offset: 1), count: 1),
                count: values.count - 1
            )
        )
        self.init(
            minimumCapacity: values.count * 2,
            deinitStrategy: .chunks(chunks),
            makingHeaderWith: { _ in header },
            thenFinishInit: {
                $0.withUnsafeMutablePointers { header, buffer in
                    header.pointee.count = values.count

                    var offset = 1
                    values.forEach { value in
                        buffer.advanced(by: offset).initialize(to: value)
                        offset += 2
                    }
                }
            }
        )
    }
}

protocol _InitTesterSafeManagedBuffer: SafeManagedBufferProtocol where HeaderValue == Void, Element == Int {}
extension _InitTesterSafeManagedBuffer {
    init(_1 _: Void) {
        self.init(
            minimumCapacity: 1,
            makingHeaderWith: { _ in },
            thenFinishInit: { _ in }
        )
    }

    init(_2 _: Void) {
        self.init(
            minimumCapacity: 1,
            makingHeaderWith: { _ in }
        )
    }

    init(_3 _: Void) {
        self.init(
            minimumCapacity: 1
        )
    }

    init(_4 _: Void) {
        self.init(
            minimumCapacity: 1,
            thenFinishInit: { _ in }
        )
    }
}

#endif
