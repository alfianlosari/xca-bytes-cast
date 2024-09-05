import SwiftUI


@MainActor
struct PostListView: View {
    
    @State var store = Store()
    
    var body: some View {
        NavigationStack {
            List {
                if let posts = store.state.data {
                    Section {
                        ForEach(posts) { post in
                            VStack(alignment: .leading) {
                                Text(post.title).font(.headline)
                                Text(post.body)
                            }
                        }
                    } 
                }
            }
            .overlay { overlayView }
            .task(id: store.taskID) {
                await store.fetchPosts()
            }
            .navigationTitle("Network Request Cache")
            #if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
        }
    }
    
    @ViewBuilder
    var overlayView: some View {
        if store.state.isLoading {
            ProgressView("Fetching Posts...")
        }
        if let error = store.state.error {
            Text(error.localizedDescription)
        }
        if let articles = store.state.data, articles.isEmpty {
            Text("No Posts")
        }
    }
}

#Preview {
    PostListView()
}
