import SwiftUI

@Observable
class ArticleStore {
    
    var articles: [Article] = Article.previewData
    
}
