import Foundation

struct Article: Identifiable, Codable {
    
    var id = UUID()
    
    let title: String
    let description: String
}
