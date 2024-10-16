//
//  CategorySidebarView.swift
//  MultiColumnSplitView
//
//  Created by Alfian Losari on 9/9/24.
//

import SwiftUI

struct CategorySidebarView: View {
    
    @Environment(NavigationModel.self) private var navigationModel
    
    var body: some View {
        @Bindable var navigationModel = navigationModel
        List(selection: $navigationModel.selectedCategory) {
            
            ForEach(Category.allCases) { category in
                NavigationLink(value: category) {
                    Label(category.text, systemImage: category.systemImage)
                }
            }
        }
        .navigationTitle("XCA News")
    }
}

#Preview {
    CategorySidebarView()
        .environment(NavigationModel())
}
