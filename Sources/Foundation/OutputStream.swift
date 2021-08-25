//
//  OutputStream.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 12/15/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if canImport(Foundation)
import Foundation

extension OutputStream {
    /// The type of errors that can be thrown by a the `OutputStream.write(allOf:...)` family of functions.
    public enum WriteAllOfError: Error {
        /// Thrown when a stream is not in an open state and an operation is attempted on it.
        case streamNotInOpenState
        /// Thrown when an output buffer is empty.
        case emptyBuffer
        /// Thrown when the stream is unable to write more bytes because the output buffer is full.
        case streamAtCapacity
        /// Thrown when the stream reports an error and has an error available to provide.
        case streamError(Error)
        /// Thrown when the stream reports an error but it doesn't have an error available to provide.
        case unknownStreamError
    }

    /// Writes all of a buffer to the `OutputStream`.
    ///
    /// - Parameters:
    ///   - buffer: A pointer to the bytes to write to the `OutputStream`.
    ///   - length: The number of bytes to write from the start of the `buffer` into the `OutputStream`.
    /// - Throws: A `WriteAllOfError` if an error occurs.
    @inlinable
    @inline(__always)
    public func write(allOf buffer: UnsafePointer<UInt8>, length: Int) throws {
        try write(allOf: .init(start: buffer, count: length))
    }

    /// Writes all of a buffer to the `OutputStream`.
    ///
    /// - Parameters:
    ///   - buffer:
    ///     A buffer pointer to the bytes to write to the output stream.
    ///     The entire buffer will be written to the `OutputStream`.
    /// - Throws: A `WriteAllOfError` if an error occurs.
    @inlinable
    public func write(allOf buffer: UnsafeBufferPointer<UInt8>) throws {
        guard !buffer.isEmpty else {
            throw WriteAllOfError.emptyBuffer
        }
        guard streamStatus == .open else {
            throw WriteAllOfError.streamNotInOpenState
        }

        var bytesWritten = 0
        repeat {
            let bytesJustWritten = write(buffer.baseAddress!, maxLength: buffer.count - bytesWritten)
            if bytesJustWritten == 0 {
                throw WriteAllOfError.streamAtCapacity
            } else if bytesJustWritten == -1 {
                throw streamError.map(WriteAllOfError.streamError) ?? WriteAllOfError.unknownStreamError
            } else {
                bytesWritten += bytesJustWritten
            }
        } while bytesWritten < buffer.count
    }
}

extension OutputStream {
    /// A function that lets you inspect or modify the writing of an `InputStream` to an `OutputStream`.
    ///
    /// - Note: See `write(allOf:maxIntermediateBufferSize:beforeEachWriteOperation:afterEachWriteOperation:)`.
    ///
    /// - Parameters:
    ///   - outputStream: The `OutputStream` that is being written to.
    ///   - inputStream: The `InputStream` that is being read and written to `outputStream`.
    ///   - buffer: The current chunk of `inputStream` data being operated on.
    public typealias WriteAllOfInputStreamOperation = (_ outputStream: OutputStream, _ inputStream: InputStream, _ buffer: UnsafeBufferPointer<UInt8>) throws -> Void

    /// Write all of the contents of an `InputStream` into this `OutputStream.`
    ///
    /// - Parameters:
    ///   - inputStream:
    ///     The `InputStream` to read from and write all of its contents to this `OutputStream`.
    ///   - maxIntermediateBufferSize:
    ///     The maximum buffer size to use for read and write operations.
    ///   - beforeEachWrite:
    ///     A function that lets you inspect this `OutputStream`, the `inputStream`, and current buffer of elements before performing the write.
    ///     If this throws it will terminate the write in its current place leaving the `OutputStream` and `inputStream` in their current states.
    ///     Genrally if you want to potentially stop writing early you should do so by throwing in `afterEachWrite` unless it is acceptable for data to be lost from both the `InputStream` and `OutputStream` contents.
    ///   - afterEachWrite:
    ///     A function that lets you inspect this `OutputStream`, the `inputStream`, and current buffer of elements after performing the write.
    ///     If this throws it will terminate the write in its current place leaving the `OutputStream` and `inputStream` in their current states.
    ///
    /// - Throws:
    ///     An `OutputStream.WriteAllOfError` if a write error occurs.
    ///     An `InputStream.ForEachChunkError` if a read error occurs.
    ///     Whatever was thrown by `beforeEachWriteOperation` or `afterEachWriteOperation`.
    @inlinable
    public func write(
        allOf inputStream: InputStream,
        maxIntermediateBufferSize: Int,
        beforeEachWrite: WriteAllOfInputStreamOperation? = nil,
        afterEachWrite: WriteAllOfInputStreamOperation? = nil
    ) throws {
        try inputStream.forEachChunk(upToSize: maxIntermediateBufferSize) { buffer in
            try beforeEachWrite?(self, inputStream, buffer)
            try write(allOf: buffer)
            try afterEachWrite?(self, inputStream, buffer)
        }
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
// extension OutputStream {
//    @inlinable
//    public static func stdout() -> OutputStream? {
//        OutputStream(toFileAtPath: "/dev/fd/\(STDOUT_FILENO)", append: true)
//    }
//
//    @inlinable
//    public static func stderr() -> OutputStream? {
//        OutputStream(toFileAtPath: "/dev/fd/\(STDERR_FILENO)", append: true)
//    }
// }
//
// #endif // canImport(Darwin) || canImport(Glibc)

#endif // canImport(Foundation)
