//
//  MutableCollection.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/10/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

extension MutableCollection {
    @usableFromInline
    @discardableResult
    mutating func stablePartition(by belongsInSecondPartition: (Element) throws -> Bool) rethrows -> Index {
        try stablePartition(count: count, by: belongsInSecondPartition)
    }

    @usableFromInline
    mutating func stablePartition(count n: Int, by belongsInSecondPartition: (Element) throws -> Bool) rethrows -> Index {
        guard n != 0 else { return startIndex }
        guard n != 1 else {
            return try belongsInSecondPartition(self[startIndex]) ? startIndex : endIndex
        }
        let offset = n / 2
        let middleIndex = index(startIndex, offsetBy: offset)
        let left = try self[..<middleIndex].stablePartition(count: offset, by: belongsInSecondPartition)
        let right = try self[middleIndex...].stablePartition(count: offset, by: belongsInSecondPartition)
        return self[left..<right].rotate(shiftingToStart: middleIndex)
    }

    @usableFromInline
    @discardableResult
    mutating func rotate(shiftingToStart middle: Index) -> Index {
        var middle = middle
        var startIndex = self.startIndex
        let endIndex = self.endIndex

        guard startIndex != middle else {
            return endIndex
        }
        guard middle != endIndex else {
            return startIndex
        }

        var result = endIndex
        while true {
            let leftIndexRange = startIndex..<middle
            let rightIndexRange = middle..<endIndex
            assert(!leftIndexRange.isEmpty)
            assert(!rightIndexRange.isEmpty)

            var leftIndex = leftIndexRange.lowerBound
            var rightIndex = rightIndexRange.lowerBound

            repeat {
                swapAt(leftIndex, rightIndex)
                formIndex(after: &leftIndex)
                formIndex(after: &rightIndex)
            } while leftIndexRange.contains(leftIndex) && rightIndexRange.contains(rightIndex)

            if rightIndex == endIndex {
                if result == endIndex {
                    result = leftIndex
                }

                if leftIndex == middle {
                    break
                }
            }

            startIndex = leftIndex
            if startIndex == middle {
                middle = rightIndex
            }
        }

        return result
    }
}
