import SwiftUI

@Observable
class ArticleStore {
    
    var articles: [Article] = []
    
    func loadArticles(category: Category) {
        self.articles = Article.previewData(category: category)
    }
    
}
