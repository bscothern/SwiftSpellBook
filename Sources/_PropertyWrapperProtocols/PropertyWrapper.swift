//
//  PropertyWrapper.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/2/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

// MARK: - PropertyWrapper
public protocol PropertyWrapper {
    associatedtype WrappedValue
    var wrappedValue: WrappedValue { get }
}

// MARK: - MutablePropertyWrapper
public protocol MutablePropertyWrapper: PropertyWrapper {
    var wrappedValue: WrappedValue { get set }
}

// MARK: - DefaultInitializablePropertyWrapper
public protocol DefaultInitializablePropertyWrapper: PropertyWrapper {
    init(wrappedValue: WrappedValue)
}

// MARK: - ProjectedPropertyWrapper
public protocol ProjectedPropertyWrapper: PropertyWrapper {
    associatedtype ProjectedValue
    var projectedValue: ProjectedValue { get }
}

// MARK: - MutableProjectedPropertyWrapper
public protocol MutableProjectedPropertyWrapper: ProjectedPropertyWrapper {
    var projectedValue: ProjectedValue { get set }
}
