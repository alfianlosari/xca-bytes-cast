import SwiftUI

@MainActor
struct ContentView: View {
    
    @State var store = Store()
    
    var body: some View {
        NavigationStack {
            List {
                if let articles = store.state.data {
                    Section { 
                        ForEach(articles) { article in 
                            VStack(alignment: .leading) {
                                Text(article.title)
                                    .font(.headline)
                                Text(article.description)
                            }
                        }
                    } footer: { 
                        Text("Last fetched date: \(store.taskID.description)")
                    }
                }
            }
            .refreshable {
                self.store.taskID = Date()
            }
            .overlay { overlayView }
            .navigationTitle("SwiftUI Task Lifecycle")
            .navigationBarTitleDisplayMode(.inline)
            .task(id: store.taskID, priority: .userInitiated) { 
                await store.fetch()
            }
            
        }
    }
    
    @ViewBuilder
    var overlayView: some View {
        if store.state.isLoading {
            ProgressView("Fetching News...")
        }
        if let error = store.state.error {
            Text(error.localizedDescription)
        }
        if let articles = store.state.data, articles.isEmpty {
            Text("No Articles")
        }
    }
}
