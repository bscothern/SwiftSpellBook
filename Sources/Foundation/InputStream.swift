//
//  InputStream.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 12/15/20.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

#if canImport(Foundation)
import Foundation

extension InputStream {
    /// Errors that can be thrown by `InputStream.forEachChunk(upToSize:_:)`.
    public enum ForEachChunkError: Error {
        /// Thrown when a stream is not in an open state and an operation is attempted on it.
        case streamNotInOpenState
        /// Thrown when the stream reports an error and has an error available to provide.
        case streamError(Error)
        /// Thrown when the stream reports an error but it doesn't have an error available to provide.
        case unknownStreamError
    }

    /// Reads from the input stream calling a given closure with each chunk being up to a maximum size.
    ///
    /// - Important:
    ///     It is not guaranteed that the buffer given to the `body` will contain `maxBufferSize` bytes.
    ///     You should always check the `buffer.count` or use a sequence operation on the buffer to ensure you work with valid bytes.
    ///
    /// - Parameters:
    ///   - maxBufferSize: The maximum buffer size to allocate and use.
    ///   - body: The body that will work with chunks of the input stream data.
    ///   - buffer: The bytes most recently read from the stream.
    ///         You should only work with first `buffer.count`.
    ///
    /// - Throws:
    ///     An `InputStream.ForEachChunkError` if an error occurs while reading the stream.
    ///     Otherwise whatever is thrown by `body`.
    @inlinable
    public func forEachChunk(
        upToSize maxBufferSize: Int,
        _ body: (_ buffer: UnsafeBufferPointer<UInt8>) throws -> Void
    ) throws {
        guard streamStatus == .open else { throw ForEachChunkError.streamNotInOpenState }

        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxBufferSize)
        defer { buffer.deallocate() }

        repeat {
            let bytesRead = read(buffer, maxLength: maxBufferSize)
            if bytesRead == 0 {
                break
            } else if bytesRead == -1 {
                throw streamError.map(ForEachChunkError.streamError) ?? ForEachChunkError.unknownStreamError
            } else {
                try body(.init(start: buffer, count: bytesRead))
            }
        } while true
    }
}

// TODO: Verify if this can be done

// #if canImport(Darwin) || canImport(Glibc)
//
// #if canImport(Darwin)
// import Darwin
// #else
// import Glibc
// #endif
//
// extension InputStream {
//    @inlinable
//    public static func stdin() -> InputStream? {
//        InputStream(fileAtPath: "/dev/fd/\(STDIN_FILENO)")
//    }
// }
//
// #endif // canImport(Darwin) || canImport(Glibc)

#endif // canImport(Foundation)
