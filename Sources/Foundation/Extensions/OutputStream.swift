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
    public enum WriteAllOfError: Error {
        case streamNotInOpenState
        case emptyBuffer
        case streamAtCapacity
        case streamError(Error?)
    }

    @inlinable
    public func write(allOf buffer: UnsafePointer<UInt8>, length: Int) throws {
        try write(allOf: .init(start: buffer, count: length))
    }

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
                throw WriteAllOfError.streamError(streamError)
            } else {
                bytesWritten += bytesJustWritten
            }
        } while bytesWritten < buffer.count
    }
}

extension OutputStream {
    public typealias WriteAllOfInputStreamOperation = (_ outputStream: OutputStream, _ inputStream: InputStream) throws -> Void

    @inlinable
    public func write(allOf inputStream: InputStream, maxIntermediateBufferSize: Int, beforeEachWriteOperation: WriteAllOfInputStreamOperation? = nil, afterEachWriteOperation: WriteAllOfInputStreamOperation? = nil) throws {
        try inputStream.forEachChunk(upToSize: maxIntermediateBufferSize) { buffer in
            try beforeEachWriteOperation?(self, inputStream)
            try write(allOf: buffer)
            try afterEachWriteOperation?(self, inputStream)
        }
    }
}

#endif
