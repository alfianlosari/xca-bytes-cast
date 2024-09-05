import SwiftUI

@Observable
@MainActor
class Store {
    
    var taskID = Date()
    
    let postsURL = URL(string: "https://dummyjson.com/posts")!
    var state = ViewState<[Post]>.idle
    
    func fetchPosts() async {
        self.state = .loading
        do {
            let (data, response) = try await URLSession.shared.data(from: postsURL)
            guard let resp = response as? HTTPURLResponse, (200...299).contains(resp.statusCode) else {
                self.state = .error("Invalid response code")
                return
            }
            try Task.checkCancellation()
            let postResponse = try JSONDecoder().decode(PostResponse.self, from: data)
            self.state = .success(postResponse.posts)
        } catch {
            if error is CancellationError {
                return
            }
            self.state = .error(error)
        }
    }

}

extension String: Error {}
