//
//  ViewModel.swift
//  ThreadSafeSendableClass
//
//  Created by Alfian Losari on 16/10/24.
//

import Foundation
import Observation

@Observable
@MainActor
public class ViewModel {
      
    let networkManager: NetworkAPIManager
    let analyticsManager: AnalyticsManager
    
    var username: String = ""
    var password: String = ""
    var user: User?
    
    var isLoginButtonDisabled: Bool {
        username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    init(networkManager: NetworkAPIManager = .shared, analyticsManager: AnalyticsManager = .shared) {
        self.networkManager = networkManager
        self.analyticsManager = analyticsManager
    }
    
    func login() async {
        do {
            let user = try await self.networkManager.login(username: username, password: password)
            try Task.checkCancellation()
            self.user = user
            self.sendUserTelemetry(user: user)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func sendUserTelemetry(user: User) {
        Task.detached { [weak self] in
            guard let self else { return }
            self.analyticsManager.trackUserDidLogin(user)
            self.analyticsManager.lastLoggedInUser = user
        }
    }
}

