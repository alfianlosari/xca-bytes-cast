//
//  ArticleListView.swift
//  MultiColumnSplitView
//
//  Created by Alfian Losari on 9/9/24.
//

import SwiftUI

struct ArticleListView: View {
    
    @State var store = ArticleStore()
    
    @Namespace var hero
    
    var body: some View {
        NavigationStack {
            ScrollView {
               ForEach(store.articles) { article in
                    NavigationLink {
                        ArticleCardView(article: article, style: .detail)
                            .navigationTransition(.zoom(sourceID: article.id, in: hero))
                    } label: {
                        ArticleCardView(article: article, style: .list)
                    }
                    .matchedTransitionSource(id: article.id, in: hero)
                    .buttonStyle(.plain)
                }
            }
            .navigationTitle("XCA ByteCast #9")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ArticleListView()
}
