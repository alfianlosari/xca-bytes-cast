//
//  NavigationModel.swift
//  MultiColumnSplitView
//
//  Created by Alfian Losari on 9/9/24.
//

import Foundation
import Observation
import SwiftUI

@MainActor
@Observable class NavigationModel {
    
    var selectedCategory: Category?
    var selectedArticle: Article?
    
    var columnVisibility: NavigationSplitViewVisibility
    var preferredCompactColumn: NavigationSplitViewColumn
    
    init(selectedCategory: Category? = .general, columnVisibility: NavigationSplitViewVisibility = .all, preferredCompactColumn: NavigationSplitViewColumn = .content) {
        self.selectedCategory = selectedCategory
        self.columnVisibility = columnVisibility
        self.preferredCompactColumn = preferredCompactColumn
    }
}
