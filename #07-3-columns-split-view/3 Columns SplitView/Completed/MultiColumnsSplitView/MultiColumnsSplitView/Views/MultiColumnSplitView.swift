//
//  MultiColumnSplitView.swift
//  MultiColumnSplitView
//
//  Created by Alfian Losari on 9/9/24.
//

import SwiftUI

struct MultiColumnSplitView: View {
    
    @Environment(NavigationModel.self) private var navigationModel
    
    var body: some View {
        @Bindable var navigationModel = navigationModel
        NavigationSplitView(columnVisibility: $navigationModel.columnVisibility, preferredCompactColumn: $navigationModel.preferredCompactColumn) {
            CategorySidebarView()
        } content: {
            ArticleListView()
        } detail: {
            ArticleDetailView()
        }

    }
}

#Preview {
    MultiColumnSplitView()
        .environment(NavigationModel())
}
