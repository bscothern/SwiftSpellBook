//
//  Result.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 3/14/23.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

extension Result where Failure == Error {
    @_disfavoredOverload
    public init(catching body: @Sendable () async throws -> Success) async {
        do {
            self = .success(try await body())
        } catch {
            self = .failure(error)
        }
    }
}
