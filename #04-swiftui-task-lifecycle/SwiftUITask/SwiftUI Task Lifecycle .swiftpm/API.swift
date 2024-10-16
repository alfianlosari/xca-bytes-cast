import Foundation

class API {
    
    func fetchArticles() async throws -> [Article] {
        try await Task.sleep(for: .milliseconds((300...600).randomElement()!))
        return Self.stubs.shuffled()
    }
    
    static let stubs = [
        Article(title: "Exploring SwiftUI", description: "An introduction to building UIs with SwiftUI."),
        Article(title: "Understanding Combine", description: "Learn how to handle asynchronous events using Combine."),
        Article(title: "Networking in Swift", description: "A guide to making network requests in Swift."),
        Article(title: "Using Core Data", description: "Manage your app’s data with Core Data."),
        Article(title: "Swift Concurrency", description: "Understand how to handle concurrency in Swift."),
        Article(title: "Swift for Beginners", description: "A beginner's guide to learning Swift programming language."),
        Article(title: "Unit Testing in Swift", description: "Learn how to write unit tests in Swift."),
        Article(title: "Working with JSON", description: "Decode and encode JSON in Swift."),
        Article(title: "Animations in SwiftUI", description: "Creating smooth animations in SwiftUI."),
        Article(title: "Design Patterns in Swift", description: "Explore common design patterns in Swift."),
        Article(title: "Building Custom Views", description: "How to create reusable custom views in SwiftUI."),
        Article(title: "Optimizing Swift Performance", description: "Tips to optimize the performance of your Swift code."),
        Article(title: "Using Protocols and Delegates", description: "Implementing protocols and delegates in Swift."),
        Article(title: "Exploring Swift Optionals", description: "A deep dive into optionals in Swift."),
        Article(title: "Error Handling in Swift", description: "Managing errors effectively in Swift."),
        Article(title: "Advanced Swift Techniques", description: "Explore advanced topics in Swift."),
        Article(title: "App Architecture", description: "Designing scalable and maintainable Swift applications."),
        Article(title: "Swift and SwiftUI", description: "How SwiftUI integrates with the Swift programming language."),
        Article(title: "Using Git with Xcode", description: "Manage your codebase with Git in Xcode."),
        Article(title: "Working with Databases", description: "Integrating SQLite and other databases in Swift."),
        Article(title: "SwiftUI Layout System", description: "Understanding the layout system in SwiftUI."),
        Article(title: "Debugging Swift Code", description: "Learn how to debug your Swift code effectively."),
        Article(title: "Using Swift Playgrounds", description: "Interactive learning and experimenting with Swift."),
        Article(title: "Memory Management in Swift", description: "Managing memory and avoiding leaks in Swift."),
        Article(title: "Swift Package Manager", description: "How to manage dependencies using Swift Package Manager.")
    ]
    
}
