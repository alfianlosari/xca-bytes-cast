import Foundation

struct PostResponse: Codable {
    let posts: [Post]
}

struct Post: Codable, Identifiable {
    let id: Int
    let title: String
    let body: String
}
