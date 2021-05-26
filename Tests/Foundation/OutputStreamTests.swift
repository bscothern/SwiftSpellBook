//
//  OutputStreamTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 5/3/21.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import SwiftFoundationSpellBook
import XCTest
import XCTestSpellBook

final class OutputStreamTests: XCTestCase {
    func testWriteAllOfNotOpened() {
        let outputStream: OutputStream = .toMemory()
        let pointer: UnsafeMutablePointer<UInt8> = .allocate(capacity: 1)
        defer {
            pointer.deinitialize(count: 1)
            pointer.deallocate()
        }
        pointer.initialize(to: 42)

        XCAssertThrownErrorIsExpected(try outputStream.write(allOf: pointer, length: 1)) { (error: OutputStream.WriteAllOfError) in
            switch error {
            case .streamNotInOpenState:
                true
            default:
                false
            }
        }
    }

    func testWriteAllEmptyBuffer() {
        let outputStream: OutputStream = .toMemory()
        outputStream.open()
        defer { outputStream.close() }

        let pointer: UnsafeMutablePointer<UInt8> = .allocate(capacity: 1)
        defer {
            pointer.deinitialize(count: 1)
            pointer.deallocate()
        }
        pointer.initialize(to: 42)

        XCAssertThrownErrorIsExpected(try outputStream.write(allOf: pointer, length: 0)) { (error: OutputStream.WriteAllOfError) in
            switch error {
            case .emptyBuffer:
                true
            default:
                false
            }
        }
    }

    func testWriteAllOfBufferLength() {
        let outputStream: OutputStream = .toMemory()
        outputStream.open()
        defer { outputStream.close() }

        let familyEmoji = "👨‍👩‍👦"
        var bytes: [UInt8] = []
        familyEmoji.utf8.forEach { (byte: UInt8) in
            bytes.append(byte)
        }

        XCTAssertNoThrow(
            try bytes.withUnsafeBytes { bytesBuffer in
                try outputStream.write(
                    allOf: bytesBuffer.baseAddress!.bindMemory(to: UInt8.self, capacity: bytesBuffer.count),
                    length: bytesBuffer.count
                )
            }
        )

        guard let data = outputStream.property(forKey: .dataWrittenToMemoryStreamKey) as? Data else {
            XCTFail("Unable to access data in outputStream")
            return
        }
        let stringFromData = String(data: data, encoding: .utf8)
        XCTAssertEqual(stringFromData, familyEmoji)
    }

    func testWriteAllOfInputStream() throws {
        let streamDataString = """
            qwertyuiop
            asdfghjkl
            zxcvbnm
            """
        let streamData = try XCTUnwrap(streamDataString.data(using: .utf8))

        let inputStream = InputStream(data: streamData)
        inputStream.open()
        defer { inputStream.close() }

        let outputStream: OutputStream = .toMemory()
        outputStream.open()
        defer { outputStream.close() }

        var beforeByteCount = 0
        var afterByteCount = 0
    
        try outputStream.write(
            allOf: inputStream,
            maxIntermediateBufferSize: 5,
            beforeEachWrite: { _outputStream, _inputStream, buffer in
                XCTAssertIdentical(outputStream, _outputStream)
                XCTAssertIdentical(inputStream, _inputStream)
                beforeByteCount += buffer.count
            },
            afterEachWrite: { _outputStream, _inputStream, buffer in
                XCTAssertIdentical(outputStream, _outputStream)
                XCTAssertIdentical(inputStream, _inputStream)
                afterByteCount += buffer.count
            }
        )

        XCTAssertEqual(streamData.count, beforeByteCount)
        XCTAssertEqual(streamData.count, afterByteCount)

        guard let data = outputStream.property(forKey: .dataWrittenToMemoryStreamKey) as? Data else {
            XCTFail("Unable to access data in outputStream")
            return
        }
        XCTAssertEqual(data, streamData)

        let stringFromData = String(data: data, encoding: .utf8)
        XCTAssertEqual(stringFromData, streamDataString)
    }

    func testWriteAllOfToCapacity() throws {
        let capacity = 10
        let buffer: UnsafeMutablePointer<UInt8> = .allocate(capacity: capacity)
        defer {
            buffer.deinitialize(count: capacity)
            buffer.deallocate()
        }

        do {
            let outputStream: OutputStream = .init(toBuffer: buffer, capacity: capacity)
            outputStream.open()
            defer { outputStream.close() }

            let bytes = Array(0 as UInt8 ..< UInt8(capacity)).shuffled()
            try bytes.withUnsafeBytes { buffer in
                try outputStream.write(allOf: buffer.bindMemory(to: UInt8.self))
            }

            for i in 0..<10 {
                XCTAssertEqual(bytes[i], buffer[i])
            }
        }

        // Apparently OutputStream.init(toBuffer:capacity) and write(_:maxLength:) don't match the documentation of them at all so that is fun...
        try XCTExpectFailure("OutputStream is behaving as expected now so this test can be updated.") {
            do {
                let outputStream: OutputStream = .init(toBuffer: buffer, capacity: capacity)
                outputStream.open()
                defer { outputStream.close() }

                let bytes = Array(0 as UInt8 ..< UInt8(capacity + 1)).shuffled()
                try bytes.withUnsafeBytes { buffer in
                    try outputStream.write(allOf: buffer.bindMemory(to: UInt8.self))
                }

                for i in 0..<(capacity + 1) {
                    XCTAssertEqual(bytes[i], buffer[i])
                }
            } catch let error as OutputStream.WriteAllOfError {
                switch error {
                case .streamAtCapacity:
                    break
                default:
                    throw error
                }
            } catch {
                throw error
            }
        }
    }
}
#endif
