//
//  Manager.swift
//  ThreadSafeSendableClass
//
//  Created by Alfian Losari on 16/10/24.
//

import Foundation

class NetworkAPIManager {
    
    static let shared = NetworkAPIManager()
    private init() {}
    
    func login(username: String, password: String) async throws -> User {
        try await Task.sleep(for: .milliseconds((100...300).randomElement()!))
        return User(id: UUID().uuidString, username: username)
    }
}

class AnalyticsManager {
    
    static let shared = AnalyticsManager()
        
    @ThreadSafe(nil) var lastLoggedInUser: User?

    func trackUserDidLogin(_ user: User) {
        // Send telemetry to server
        print("Telemetry Sent for userDidLogin: \(user)")
    }
}
