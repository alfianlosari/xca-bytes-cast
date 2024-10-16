//
//  Article.swift
//  XCANews
//
//  Created by Alfian Losari on 6/27/21.
//

import Foundation

fileprivate let relativeDateFormatter = RelativeDateTimeFormatter()

struct Article: Hashable {
    let id = UUID()
    
    let source: Source
    
    var title: String
    let url: String
    let publishedAt: Date
    
    let author: String?
    var description: String?
    let urlToImage: String?
    var content: String
    
    enum CodingKeys: String, CodingKey {
        case source
        case title
        case url
        case publishedAt
        case author
        case description
        case urlToImage
        case content
    }
    
    var authorText: String {
        author ?? ""
    }
    
    var descriptionText: String {
        description ?? ""
    }
    
    func localizedCaptionText(lang: Locale.Language? = nil) -> String {
        let lang = lang ?? Locale.Language(identifier: "en")
        relativeDateFormatter.locale = Locale(languageComponents: .init(language: lang))
        
        return "\(source.name) ‧ \(relativeDateFormatter.localizedString(for: publishedAt, relativeTo: Date()))"
    }
    
    var captionText: String {
        "\(source.name) ‧ \(relativeDateFormatter.localizedString(for: publishedAt, relativeTo: Date()))"
    }
    
    var articleURL: URL {
        URL(string: url)!
    }
    
    var imageURL: URL? {
        guard let urlToImage = urlToImage else {
            return nil
        }
        return URL(string: urlToImage)
    }
    
}

extension Article: Codable {}
extension Article: Equatable {}
extension Article: Identifiable {}


struct Source: Hashable {
    let name: String
}

extension Source: Codable {}
extension Source: Equatable {}

struct NewsAPIResponse: Decodable {
    
    let status: String
    let totalResults: Int?
    let articles: [Article]?
    
    let code: String?
    let message: String?
    
}
