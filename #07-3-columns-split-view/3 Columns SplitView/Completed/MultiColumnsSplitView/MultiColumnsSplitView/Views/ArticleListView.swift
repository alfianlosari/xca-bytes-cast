//
//  ArticleListView.swift
//  MultiColumnSplitView
//
//  Created by Alfian Losari on 9/9/24.
//

import SwiftUI

struct ArticleListView: View {
    
    @Environment(NavigationModel.self) private var navigationModel
    @State var store = ArticleStore()
    
    var body: some View {
        if let selectedCategory = navigationModel.selectedCategory {
            @Bindable var navigationModel = navigationModel
            List(selection: $navigationModel.selectedArticle) {
                ForEach(store.articles) { article in
                    NavigationLink(value: article) {
                        ArticleView(article: article)
                    }
                }
            }
            .task(id: navigationModel.selectedCategory) {
                if let category = navigationModel.selectedCategory {
                    store.loadArticles(category: category)
                }
            }
            .navigationTitle(selectedCategory.text)
        } else {
            ContentUnavailableView("Select a category", systemImage: "circle.hexagongrid.fill", description: Text("Pick category from sidebar"))
        }
    }
}

#Preview {
    ArticleListView()
        .environment(NavigationModel())
}

#Preview {
    ArticleListView()
        .environment(NavigationModel(selectedCategory: nil))
}
