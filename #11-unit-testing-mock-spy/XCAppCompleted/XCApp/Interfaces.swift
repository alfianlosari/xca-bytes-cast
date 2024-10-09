//
//  Protocols.swift
//  XCApp
//
//  Created by Alfian Losari on 08/10/24.
//

import Foundation

/// @mockable(history: trackSaveButtonDidTapped = true; trackDidFetchUser =  true)
protocol AnalyticsManagerInterface {
    
    func trackSaveButtonDidTapped(source: String)
    func trackDidFetchUser(_ user: User)
    
}

/// @mockable(history: saveNumber = true)
protocol DatabaseManagerInterface {
    
    func saveNumber(_ number: Int)
}

/// @mockable(history: fetchUser = true)
protocol NetworkManagerInterface {
    
    func fetchUser(username: String) async throws -> User
    
}

/// @mockable(history: shouldFetchUserOnViewAppear = true)
protocol RemoteConfigInterface {
    
    var shouldFetchUserOnViewAppear: Bool { get }

}
