import SwiftUI

@Observable
@MainActor
class Store {

    var taskID = Date()
    let api = API()
    var state = ViewState<[Article]>.idle
    
    func fetch() async {
        self.state = .loading
        do {
            let articles = try await api.fetchArticles()
            try Task.checkCancellation()
            self.state = .success(articles)
        } catch {
            if error is CancellationError {
                return
            }
            self.state = .error(error)
        }
    }
}
