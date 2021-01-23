//
//  Zip3.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/9/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

/// Creates a sequence of 3 values built out of 3 underlying sequences.
///
/// In the sequence returned by this function, the elements of the *i*th set of values are the *i*th elements of each underlying sequence.
///  The
/// following example uses the `zip(_:_:_:)` function to iterate over an array
/// of strings and two countable ranges at the same time:
///
///     let words = ["abc", "foo", "bar", "baz"]
///     let numbers = 1...4
///     let moreNumbers = 10...13
///
///     for (word, number, anotherNumber) in zip(words, numbers, moreNumbers) {
///         print("\(word) - \(number) - \(anotherNumber)")
///     }
///     // Prints "abc - 1 - 10"
///     // Prints "foo - 2 - 11"
///     // Prints "bar - 3 - 12"
///     // Prints "baz - 4 - 13"
///
/// If the three sequences passed to `zip(_:_:_:)` are different lengths, the resulting sequence is the same length as the shorter sequence.
///
/// - Parameters:
///   - sequence1: The first sequence or collection to zip.
///   - sequence2: The second sequence or collection to zip.
///   - sequence3: The third sequence or collection to zip.
/// - Returns: A sequence of tuple values, where the elements of each set are
///   corresponding elements of `sequence1`, `sequence2`, and `sequence3`.
@inlinable
public func zip<Sequence1, Sequence2, Sequence3>(_ sequence1: Sequence1, _ sequence2: Sequence2, _ sequence3: Sequence3) -> AnySequence<(Sequence1.Element, Sequence2.Element, Sequence3.Element)> where Sequence1: Sequence, Sequence2: Sequence, Sequence3: Sequence {
    var iterators = (sequence1.makeIterator(), sequence2.makeIterator(), sequence3.makeIterator())
    return AnySequence {
        AnyIterator {
            guard let sequence1Value = iterators.0.next(),
                  let sequence2Value = iterators.1.next(),
                  let sequence3Value = iterators.2.next() else {
                return nil
            }
            return (sequence1Value, sequence2Value, sequence3Value)
        }
    }
}
