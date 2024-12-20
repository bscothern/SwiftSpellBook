//
//  InputStreamTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 5/3/21.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import SwiftFoundationSpellBook
import XCTest
import XCTestSpellBook

final class InputStreamTests: XCTestCase {
    override func tearDown() {
        super.tearDown()
        stream = nil
        streamData = nil
    }

//    func testForEachNotOpen() {
//        XCAssertThrownErrorIsExpected(try stream.forEachChunk(upToSize: 11) { _ in }) { (error: InputStream.ForEachChunkError) in
//            switch error {
//            case .streamNotInOpenState:
//                true
//            default:
//                false
//            }
//        }
//    }
//
//    func testForEachNotOpen2() {
//        XCAssertThrownErrorIsExpected(try stream.forEachChunk(upToSize: 11) { _ in }) { (error: InputStream.ForEachChunkError) in
//            switch error {
//            case .streamNotInOpenState:
//                true
//            default:
//                false
//            }
//        }
//    }

    func testForEachChunk() throws {
        let maxChunkSize = 10

        stream.open()
        defer { stream.close() }
        var step = 0
        let values: [Character] = .init(Self.streamDataString)
        try stream.forEachChunk(upToSize: maxChunkSize) { buffer in
            XCTAssertLessThanOrEqual(buffer.count, maxChunkSize)
            let currentCharacters = buffer.lazy.map(UnicodeScalar.init).map(Character.init)
            currentCharacters.forEach { character in
                XCTAssertEqual(character, values[step])
                step += 1
            }
        }
    }

    lazy var stream: InputStream! = InputStream(data: streamData)

    lazy var streamData: Data! = Self.streamDataString.data(using: .utf8)!

    static let streamDataString = """
    1234567890
    ABCDEFGHIJ
    KLMNOPQRST
    UVWXYZ[]{}
    """
}
#endif
