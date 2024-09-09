//
//  ArticleDetailView.swift
//  MultiColumnSplitView
//
//  Created by Alfian Losari on 9/9/24.
//

import SwiftUI

struct ArticleDetailView: View {
    
    @Environment(NavigationModel.self) private var navigationModel
    
    var body: some View {
        if let selectedArticle = navigationModel.selectedArticle {
            WebView(url: selectedArticle.articleURL)
                .id(selectedArticle.articleURL)
                .navigationTitle(selectedArticle.title)
        } else {
            ContentUnavailableView("Select an article", systemImage: "newspaper.fill", description: Text("Select an article from the list"))
        }
    }
}

#Preview {
    ArticleDetailView()
        .environment(NavigationModel())
}
