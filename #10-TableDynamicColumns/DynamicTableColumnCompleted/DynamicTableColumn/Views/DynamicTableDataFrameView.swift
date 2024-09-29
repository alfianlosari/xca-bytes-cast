//
//  DynamicTableDataFrameView.swift
//  DynamicTableColumn
//
//  Created by Alfian Losari on 26/09/24.
//

import Foundation
import SwiftUI

struct DynamicTableDataFrameView: View {
    
    let tableData: DynamicTableData
        
    var body: some View {
        Table(tableData.rows) {
            TableColumnForEach(tableData.cols) { colWrapper in
                TableColumn(colWrapper.name) { rowWrappper in
                    Text(rowWrappper.string(columnWrapper: colWrapper))
                }
            }
        }
    }
}
