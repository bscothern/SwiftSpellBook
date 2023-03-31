//
//  ZipMatrix.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/19/20.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

public struct ZipMatrix<Row, Column> where Row: Collection, Column: Collection {
    @usableFromInline
    let row: Row

    @usableFromInline
    let rowCount: Int

    @usableFromInline
    let column: Column

    @usableFromInline
    let columnCount: Int

    @usableFromInline
    init(_row row: Row, column: Column) {
        self.row = row
        rowCount = row.count
        self.column = column
        columnCount = column.count
    }

    public init(row: Row, column: Column) {
        self.init(_row: row, column: column)
    }
}

extension ZipMatrix: Collection {
    public struct Index: Comparable {
        @usableFromInline
        var rowIndex: Row.Index

        @usableFromInline
        var columnIndex: Column.Index

        @usableFromInline
        init(rowIndex: Row.Index, columnIndex: Column.Index) {
            self.rowIndex = rowIndex
            self.columnIndex = columnIndex
        }

        @inlinable
        public static func < (lhs: Self, rhs: Self) -> Bool {
            if lhs.rowIndex < rhs.rowIndex {
                return true
            } else if lhs.rowIndex == rhs.rowIndex {
                return lhs.columnIndex < rhs.columnIndex
            } else {
                return false
            }
        }
    }

    @inlinable
    public var startIndex: Index {
        .init(rowIndex: row.startIndex, columnIndex: column.startIndex)
    }

    @inlinable
    public var endIndex: Index {
        .init(rowIndex: row.endIndex, columnIndex: column.endIndex)
    }

    @inlinable
    public subscript(position: Index) -> (Row.Element, Column.Element) {
        (row[position.rowIndex], column[position.columnIndex])
    }

    @inlinable
    public func index(after i: Index) -> Index {
        let columnIndex = column.index(after: i.columnIndex)
        guard columnIndex == column.endIndex else {
            return .init(rowIndex: i.rowIndex, columnIndex: columnIndex)
        }

        let rowIndex = row.index(after: i.rowIndex)
        guard rowIndex == row.endIndex else {
            return .init(rowIndex: rowIndex, columnIndex: column.startIndex)
        }
        return endIndex
    }
}
