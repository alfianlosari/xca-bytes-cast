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
                if !store.availableLanguages.isEmpty {
                    HStack {
                        Text("Target ")
                        Picker("Target ", selection: $store.selectedTo) {
                            ForEach(store.availableLanguages) { language in
                                Text(language.localizedName())
                                    .tag(Optional(language.locale))
                            }
                        }
                        .disabled(store.isTranslating)
                        
                        Button("Translate") {
                            store.triggerTranslation()
                        }
                        .disabled(store.isTranslating)
                        .buttonStyle(.borderedProminent)
                    }
                }
                
                ForEach(store.articles) { article in
                    NavigationLink {
                        ArticleCardView(article: article, style: .detail, isTranslating: store.isTranslating, language: store.articleDetailLanguage)
                            .navigationTransition(.zoom(sourceID: article.id, in: hero))
                    } label: {
                        ArticleCardView(article: article, style: .list, isTranslating: store.isTranslating, language: store.articleDetailLanguage)
                    }
                    .matchedTransitionSource(id: article.id, in: hero)
                    .buttonStyle(.plain)
                }
            }
            .navigationTitle("XCA ByteCast #9")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Reset") {
                    store.translatedArticles = nil
                }
                .disabled(store.isTranslating)
            }
            .translationTask(store.configuration) {
                await store.translateBatch(using: $0)
            }
        }
    }
}

#Preview {
    ArticleListView()
}
