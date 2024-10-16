//
//  ArticleListView.swift
//  MultiColumnSplitView
//
//  Created by Alfian Losari on 9/9/24.
//

import SwiftUI

struct ArticleListView: View {
    
    @State var articles: [Article] = Article.previewData
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(articles) { article in
                    NavigationLink {
                        ArticleCardView(article: article, style: .detail)
                    } label: {
                        ArticleCardView(article: article, style: .list)
                    }
                    .buttonStyle(.plain)
                }
            }
            .navigationTitle("XCA ByteCast #8")
            .toolbarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ArticleListView()
}
