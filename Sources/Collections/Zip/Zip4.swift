//
//  Zip4.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/9/20.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

/// Creates a sequence of 4 values built out of 4 underlying sequences.
///
/// In the sequence returned by this function, the elements of the *i*th set of values are the *i*th elements of each underlying sequence.
///  The
/// following example uses the `zip(_:_:_:)` function to iterate over an array
/// of strings and two countable ranges at the same time:
///
///     let words = ["abc", "foo", "bar", "baz"]
///     let numbers = 1...4
///     let moreNumbers = 10...13
///     let characters = ["a", "b", "c", "d"]
///
///     for (word, number, anotherNumber, character) in zip(words, numbers, moreNumbers, characters) {
///         print("\(word) - \(number) - \(anotherNumber) - \(character)")
///     }
///     // Prints "abc - 1 - 10 - a"
///     // Prints "foo - 2 - 11 - b"
///     // Prints "bar - 3 - 12 - c"
///     // Prints "baz - 4 - 13 - d"
///
/// If the three sequences passed to `zip(_:_:_:)` are different lengths, the resulting sequence is the same length as the shorter sequence.
///
/// - Parameters:
///   - sequence1: The first sequence or collection to zip.
///   - sequence2: The second sequence or collection to zip.
///   - sequence3: The third sequence or collection to zip.
///   - sequence4: The fourth sequence or collection to zip.
/// - Returns: A sequence of tuple values, where the elements of each set are
///   corresponding elements of `sequence1`, `sequence2`, `sequence3`, and `sequence4`.
@inlinable
public func zip<Sequence1, Sequence2, Sequence3, Sequence4>(
    _ sequence1: Sequence1,
    _ sequence2: Sequence2,
    _ sequence3: Sequence3,
    _ sequence4: Sequence4
) -> AnySequence<(Sequence1.Element, Sequence2.Element, Sequence3.Element, Sequence4.Element)>
where Sequence1: Sequence,
      Sequence2: Sequence,
      Sequence3: Sequence,
      Sequence4: Sequence {
    var iterators = (sequence1.makeIterator(), sequence2.makeIterator(), sequence3.makeIterator(), sequence4.makeIterator())
    return AnySequence {
        AnyIterator {
            guard let sequence1Value = iterators.0.next(),
                  let sequence2Value = iterators.1.next(),
                  let sequence3Value = iterators.2.next(),
                  let sequence4Value = iterators.3.next() else {
                return nil
            }
            return (sequence1Value, sequence2Value, sequence3Value, sequence4Value)
        }
    }
}
