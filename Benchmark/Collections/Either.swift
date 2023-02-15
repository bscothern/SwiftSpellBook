//
//  Either.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 4/5/21.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

import CollectionsBenchmark
import SwiftCollectionsSpellBook

extension Benchmark {
    mutating func addEitherBenchmarks() {
        addSimple(
            title: "Either Append",
            input: Int.self,
            body: { _ in
            }
        )
    }
}
