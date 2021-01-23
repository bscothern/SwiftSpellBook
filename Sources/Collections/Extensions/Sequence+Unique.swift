//
//  Sequence+Unique.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 12/11/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

extension Sequence {
    @inlinable
    public func uniqueElements() -> [Element] where Element: Hashable {
        var seenElements: Set<Element> = []
        return filter { seenElements.insert($0).inserted }
    }

    @available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
    @inlinable
    public func uniqueElements() -> [Element] where Element: Identifiable {
        var seenElements: Set<Element.ID> = []
        return filter { seenElements.insert($0.id).inserted }
    }
}
