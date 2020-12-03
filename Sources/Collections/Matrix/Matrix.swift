//
//  Matrix.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/19/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

public struct Matrix<Row, Column> where Row: Collection, Column: Collection {
    @usableFromInline
    let row: Row

    @usableFromInline
    let column: Column

    public init(row: Row, column: Column) {
        self.row = row
        self.column = column
    }
}

extension Matrix: Collection {
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
            guard lhs.rowIndex != rhs.rowIndex else {
                return lhs.columnIndex < rhs.columnIndex
            }
            return lhs.rowIndex < rhs.rowIndex
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
        let rowIndex = row.index(after: i.rowIndex)
        guard rowIndex != row.endIndex else {
            return .init(rowIndex: row.startIndex, columnIndex: column.index(after: i.columnIndex))
        }
        return .init(rowIndex: rowIndex, columnIndex: i.columnIndex)
    }

    @inlinable
    public func index(_ i: Index, offsetBy distance: Int) -> Index {
        fatalError()
    }

    @inlinable
    public func index(_ i: Index, offsetBy distance: Int, limitedBy limit: Index) -> Index? {
        fatalError()
    }

    @inlinable
    public func distance(from start: Index, to end: Index) -> Int {
        fatalError()
    }
}

extension Matrix {
    public struct RowLens: Collection {
        public typealias Index = Column.Index

        @usableFromInline
        let base: Matrix

        @usableFromInline
        let rowIndex: Row.Index

        @usableFromInline
        init(base: Matrix, rowIndex: Row.Index) {
            self.base = base
            self.rowIndex = rowIndex
        }

        @inlinable
        public var startIndex: Index { base.column.startIndex }

        @inlinable
        public var endIndex: Index { base.column.endIndex }

        @inlinable
        public subscript(position: Index) -> Matrix.Element {
            base[.init(rowIndex: rowIndex, columnIndex: position)]
        }

        @inlinable
        public func index(after i: Index) -> Index {
            base.column.index(after: i)
        }
    }

    @inlinable
    public subscript(row: Row.Index) -> Matrix.RowLens {
        RowLens(base: self, rowIndex: row)
    }
}

extension Matrix {
    public struct ColumnLens: Collection {
        public typealias Index = Row.Index

        @usableFromInline
        let base: Matrix

        @usableFromInline
        let columnIndex: Column.Index

        @inlinable
        public var startIndex: Index { base.row.startIndex }

        @inlinable
        public var endIndex: Index { base.row.endIndex }

        @usableFromInline
        init(base: Matrix, columnIndex: Column.Index) {
            self.base = base
            self.columnIndex = columnIndex
        }

        @inlinable
        public subscript(position: Index) -> Matrix.Element {
            base[.init(rowIndex: position, columnIndex: columnIndex)]
        }

        @inlinable
        public func index(after i: Index) -> Index {
            base.row.index(after: i)
        }
    }

    @inlinable
    public subscript(column: Column.Index) -> Matrix.ColumnLens {
        ColumnLens(base: self, columnIndex: column)
    }
}
