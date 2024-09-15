import SwiftUI

enum ArticleCardStyle {
    case list
    case detail
}

struct ArticleCardView: View {
    
    let article: Article
    let style: ArticleCardStyle
    
    var body: some View {
        switch style {
        case .list:
            VStack(alignment: .leading, spacing: 0) {
                asyncImage
                    .frame(minHeight: 200, maxHeight: 300)
                    .background(Color.gray.opacity(0.6))
                    .clipped()
                    
                VStack(alignment: .leading, spacing: 8) {
                    Text(article.title)
                        .font(.headline)
                        .lineLimit(3)
                    Text(article.captionText)
                        .lineLimit(1)
                        .font(.caption)
                }
                .padding([.horizontal, .bottom], 16)
                .padding(.top, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(.ultraThinMaterial)
            .hoverEffect()
            .clipShape(.rect(cornerRadius: 10))
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
            
        case .detail:
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    asyncImage
                        .frame(minHeight: 200, maxHeight: 600)
                        .background(Color.gray.opacity(0.6))
                        .clipped()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(article.title)
                            .font(.headline)
                        Text(article.captionText)
                            .font(.caption)
                    }
                    .padding([.horizontal, .bottom], 16)
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.ultraThinMaterial)
                    
                    
                    Text(article.content)
                        .padding(16)
                }
            }
        }
    }

    private var asyncImage: some View {
        CachedAsyncImage(url: article.imageURL, urlCache: .imageCache) { phase in
              switch phase {
              case .empty:
                  HStack {
                      Spacer()
                      ProgressView()
                      Spacer()
                  }
              case .success(let image):
                  image
                      .resizable()
                      .scaledToFill()
                  
              case .failure:
                  HStack {
                      Spacer()
                      Image(systemName: "photo")
                          .imageScale(.large)
                      Spacer()
                  }
              @unknown default:
                  EmptyView()
              }
          }
       
      }
}

#Preview("List Style") {
    ScrollView {
        ForEach(Article.previewData) {
            ArticleCardView(article: $0, style: .list)
        }
    }
}

#Preview("Detail Style") {
    NavigationStack {
        ScrollView {
            ArticleCardView(article: .previewData[0], style: .detail)
        }
    }
}
