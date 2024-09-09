import SwiftUI

struct ArticleView: View {
    
    let article: Article 
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(article.title)
                .padding(.bottom, 8)
#if os(iOS)
                .font(.headline)
#elseif os(macOS)
                .font(.title2.bold())
                .foregroundStyle(.primary)
#endif
                .lineLimit(3)
            
            Text(article.descriptionText)
#if os(iOS)
                .font(.subheadline)
                .lineLimit(2)
#elseif os(macOS)
                .font(.body)
                .foregroundStyle(.secondary)
                .lineSpacing(2)
                .lineLimit(3)
#endif
            
            Text(article.captionText)
                .lineLimit(1)
                
                .font(.caption)
                .padding(.top)
            
        }
    }
    
}
