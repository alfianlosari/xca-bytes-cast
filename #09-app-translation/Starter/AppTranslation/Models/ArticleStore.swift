import SwiftUI


@Observable
@MainActor
class ArticleStore {
    
    var articles: [Article] = Article.previewData
    
}
