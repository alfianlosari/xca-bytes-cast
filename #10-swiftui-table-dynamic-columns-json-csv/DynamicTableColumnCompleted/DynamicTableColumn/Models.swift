//
//  Models.swift
//  DynamicTableColumn
//
//  Created by Alfian Losari on 26/09/24.
//

import Foundation
import TabularData

struct DynamicTableData: Identifiable {
    
    let id = UUID()
    
    let rows: [RowWrapper]
    let cols: [ColumnWrapper]
    
    init(dataFrame: DataFrame) {
        self.rows = dataFrame.rows.map { .init(row: $0) }
        self.cols = dataFrame.columns.enumerated().map { .init(index: $0, col: $1) }
    }
}

struct RowWrapper: Identifiable {
    let id = UUID()
    let row: DataFrame.Rows.Element
    
    func string(columnWrapper: ColumnWrapper) -> String {
        guard let val = row[columnWrapper.index] else { return "" }
        return "\(val)"
    }
}

struct ColumnWrapper: Identifiable {
    let id = UUID()
    let index: Int
    let col: TabularData.AnyColumn
    
    var name: String {
        col.name
    }
}
