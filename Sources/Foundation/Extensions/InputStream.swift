//
//  InputStream.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 12/15/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if canImport(Foundation)
import Foundation

extension InputStream {
    public enum ForEachChunkError: Error {
        case streamNotInOpenState
        case streamError(Error?)
    }
    
    @inlinable
    public func forEachChunk(upToSize maxBufferSize: Int, _ body: (_ buffer: UnsafeBufferPointer<UInt8>) throws -> Void) throws {
        guard streamStatus == .open else { throw ForEachChunkError.streamNotInOpenState }
        
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxBufferSize)
        defer { buffer.deallocate() }
        
        repeat {
            let bytesRead = read(buffer, maxLength: maxBufferSize)
            if bytesRead == 0 {
                break
            } else if bytesRead == -1 {
                throw ForEachChunkError.streamError(streamError)
            } else {
                try body(.init(start: buffer, count: bytesRead))
            }
        } while true
    }
}

#endif
