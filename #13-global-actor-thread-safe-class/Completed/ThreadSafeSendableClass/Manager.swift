//
//  Manager.swift
//  ThreadSafeSendableClass
//
//  Created by Alfian Losari on 16/10/24.
//

import Foundation

@globalActor
actor NetworkActor {
    static let shared = NetworkActor()
}

@NetworkActor
class NetworkAPIManager {
    
    static nonisolated let shared = NetworkAPIManager()
    private nonisolated init() {}
    
    func login(username: String, password: String) async throws -> User {
        try await Task.sleep(for: .milliseconds((100...300).randomElement()!))
        return User(id: UUID().uuidString, username: username)
    }
}

@globalActor
actor AnalyticsActor {
    static let shared = AnalyticsActor()
}

@AnalyticsActor
class AnalyticsManager: @unchecked Sendable {
    
    static nonisolated let shared = AnalyticsManager()
    private nonisolated init() {}
        
    var lastLoggedInUser: User?

    func trackUserDidLogin(_ user: User) {
        // Send telemetry to server
        print("Telemetry Sent for userDidLogin: \(user)")
    }
}
