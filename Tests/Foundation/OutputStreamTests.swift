//
//  OutputStreamTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 5/3/21.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import SwiftFoundationSpellBook
import XCTestSpellBook
import XCTest

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
                return true
            default:
                return false
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
                return true
            default:
                return false
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
            beforeEachWriteOperation: { _outputStream, _inputStream, buffer in
                XCTAssertIdentical(outputStream, _outputStream)
                XCTAssertIdentical(inputStream, _inputStream)
                beforeByteCount += buffer.count
            },
            afterEachWriteOperation: { _outputStream, _inputStream, buffer in
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
}
#endif
