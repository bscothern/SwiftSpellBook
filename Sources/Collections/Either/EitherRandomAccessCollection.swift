//
//  EitherRandomAccessCollection.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 12/2/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

public typealias EitherRandomAccessCollection<Left, Right> = EitherCollection<Left, Right> where Left: RandomAccessCollection, Right: RandomAccessCollection, Left.Element == Right.Element
extension EitherRandomAccessCollection: RandomAccessCollection {}
