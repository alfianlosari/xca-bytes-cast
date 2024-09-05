import SwiftUI

@Observable
@MainActor
class Store {
    
    var taskID = Date()
    
    let postsURL = URL(string: "https://dummyjson.com/posts")!
    var state = ViewState<[Post]>.idle
    let cache: NetworkCache<PostResponse>
    
    init(cache: NetworkCache<PostResponse> = .init()) {
        self.cache = cache
    }
    
    func setExpirationTimestampHandler() async {
        if await cache.expiredTimestampProvider == nil {
            await cache.set { _ in
//                Calendar.current.date(byAdding: .minute, value: 5, to: .now)
                nil
            }
        }
    }
    
    func fetchPosts() async {
        self.state = .loading
        do {
            let postResponse = try await cache.value(from: .init(url: postsURL))
            try Task.checkCancellation()
            self.state = .success(postResponse?.posts ?? [])
        } catch {
            if error is CancellationError {
                return
            }
            self.state = .error(error)
        }
    }
    
    func invalidateCache() async {
        await cache.invalidateCache()
    }

}

extension String: Error {}
