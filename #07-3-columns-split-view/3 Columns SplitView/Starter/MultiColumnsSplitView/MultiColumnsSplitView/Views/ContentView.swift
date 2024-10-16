import SwiftUI

struct ContentView: View {

    @State var store = ArticleStore()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(store.articles) { article in
                    NavigationLink(destination: WebView(url: article.articleURL)) { 
                        ArticleView(article: article)
                    }
                }
            }.task {
                store.loadArticles(category: .general)
            }
        }
    }
}
