//
//  OutputStream.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 12/15/20.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
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

/// A `TextOutputStream` that tracks the most recent `Error` raised while writing.
public protocol TextOutputStreamWithWriteError: TextOutputStream {
    /// The last `Error`, if any, raised while perroming a write operation.
    var writeError: (any Error)? { get }
}

extension OutputStream {
    @usableFromInline
    struct _OutputStreamTextOutputStream: TextOutputStreamWithWriteError {
        @usableFromInline
        let outputStream: OutputStream
        
        @usableFromInline
        var writeError: (any Error)?
        
        @usableFromInline
        init(_ outputStream: OutputStream) {
            self.outputStream = outputStream
            writeError = nil
        }

        @usableFromInline
        mutating func write(_ string: String) {
            do {
                try string.utf8.withContiguousStorageIfAvailable { utf8 in
                    try outputStream.write(allOf: utf8)
                }
            } catch {
                writeError = error
            }
        }
    }

    /// Creates a `TextOutputStream` that writes to the `OutputStream`.
    ///
    /// - Note: If the `OutputStream` is not in the open state (see `streamStatus`) this will attemt to open it by calling `open()`.
    ///     If the open operation fails then `nil` is returned.
    public func textOutputStream() -> (some TextOutputStreamWithWriteError)? {
        if self.streamStatus != .open {
            self.open()
            guard self.streamStatus == .open else {
                return _OutputStreamTextOutputStream?.none
            }
        }
        return _OutputStreamTextOutputStream(self)
    }
}

#if canImport(Darwin) || canImport(Glibc)
#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#else
// TODO: add windows streams support
#endif

extension OutputStream {
    /// Attempts to creates an `OutputStream` that duplicates the file descriptor for standard out.
    ///
    /// - Parameter shouldOpen: If the stream should have `open()` called on it right away
    /// - Returns: An `OutputStream` for standard out if it could be created otherwise `nil`.
    @inlinable
    public static func standardOut(shouldOpen: Bool = true) -> OutputStream? {
        let filePath = "/dev/fd/\(STDOUT_FILENO)"
        let outputStream = OutputStream(toFileAtPath: filePath, append: true)
        if shouldOpen {
            outputStream?.open()
        }
        return outputStream
    }

    /// Attempts to creates an `OutputStream` that duplicates the file descriptor for standard error.
    ///
    /// - Parameter shouldOpen: If the stream should have `open()` called on it right away
    /// - Returns: An `OutputStream` for standard error if it could be created otherwise `nil`.
    @inlinable
    public static func standardError(shouldOpen: Bool = true) -> OutputStream? {
        let filePath = "/dev/fd/\(STDERR_FILENO)"
        let outputStream = OutputStream(toFileAtPath: filePath, append: true)
        if shouldOpen {
            outputStream?.open()
        }
        return outputStream
    }
    
    /// Attempts to creates an `OutputStream` that writes to the null device.
    ///
    /// - Parameter shouldOpen: If the stream should have `open()` called on it right away
    /// - Returns: An `OutputStream` for null device if it could be created otherwise `nil`.
    @inlinable
    public static func null(shouldOpen: Bool = true) -> OutputStream? {
        let filePath = "/dev/null"
        let nullStream = OutputStream(toFileAtPath: filePath, append: true)
        if shouldOpen {
            nullStream?.open()
        }
        return nullStream
    }
}
#endif // canImport(Darwin) || canImport(Glibc)
#endif // canImport(Foundation)
