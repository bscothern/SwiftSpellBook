//
//  ZipMatrix.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/19/20.
//  Copyright © 2020-2022 Braden Scothern. All rights reserved.
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
            guard lhs.columnIndex != rhs.columnIndex else {
                return lhs.rowIndex < rhs.rowIndex
            }
            return lhs.columnIndex < rhs.columnIndex
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
            return endIndex
        }

        return .init(rowIndex: rowIndex, columnIndex: column.startIndex)
    }

    @inlinable
    public func index(_ i: Index, offsetBy distance: Int) -> Index {
        if let columnIndex = column.index(i.columnIndex, offsetBy: distance, limitedBy: column.endIndex) {
            guard columnIndex != column.endIndex else {
                return .init(rowIndex: i.rowIndex, columnIndex: columnIndex)
            }

            let rowIndex = row.index(after: i.rowIndex)
            if rowIndex != row.endIndex {
                return .init(rowIndex: rowIndex, columnIndex: column.startIndex)
            } else {
                return endIndex
            }
        } else {
            let remainingRowDistance = column.distance(from: i.columnIndex, to: column.endIndex)
            var distanceToGo = distance - remainingRowDistance
            var rowOffset = 1
            while distanceToGo > columnCount {
                distanceToGo -= columnCount
                rowOffset += 1
            }

            return .init(rowIndex: row.index(i.rowIndex, offsetBy: rowOffset), columnIndex: column.index(column.startIndex, offsetBy: distanceToGo))
        }
    }

    @inlinable
    public func index(_ i: Index, offsetBy distance: Int, limitedBy limit: Index) -> Index? {
        #warning("TODO")
        fatalError("TODO")
    }

    @inlinable
    public func distance(from start: Index, to end: Index) -> Int {
        #warning("TODO")
        fatalError("TODO")
    }
}

extension ZipMatrix {
    public struct RowLens: Collection {
        public typealias Index = Column.Index

        @usableFromInline
        let base: ZipMatrix

        @usableFromInline
        let rowIndex: Row.Index

        @usableFromInline
        init(base: ZipMatrix, rowIndex: Row.Index) {
            self.base = base
            self.rowIndex = rowIndex
        }

        @inlinable
        public var startIndex: Index { base.column.startIndex }

        @inlinable
        public var endIndex: Index { base.column.endIndex }

        @inlinable
        public subscript(position: Index) -> ZipMatrix.Element {
            base[.init(rowIndex: rowIndex, columnIndex: position)]
        }

        @inlinable
        public func index(after i: Index) -> Index {
            base.column.index(after: i)
        }
    }

    @inlinable
    public subscript(row: Row.Index) -> ZipMatrix.RowLens {
        RowLens(base: self, rowIndex: row)
    }
}

extension ZipMatrix {
    public struct ColumnLens: Collection {
        public typealias Index = Row.Index

        @usableFromInline
        let base: ZipMatrix

        @usableFromInline
        let columnIndex: Column.Index

        @inlinable
        public var startIndex: Index { base.row.startIndex }

        @inlinable
        public var endIndex: Index { base.row.endIndex }

        @usableFromInline
        init(base: ZipMatrix, columnIndex: Column.Index) {
            self.base = base
            self.columnIndex = columnIndex
        }

        @inlinable
        public subscript(position: Index) -> ZipMatrix.Element {
            base[.init(rowIndex: position, columnIndex: columnIndex)]
        }

        @inlinable
        public func index(after i: Index) -> Index {
            base.row.index(after: i)
        }
    }

    @inlinable
    public subscript(column: Column.Index) -> ZipMatrix.ColumnLens {
        ColumnLens(base: self, columnIndex: column)
    }
}
