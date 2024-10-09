//
//  ViewModel.swift
//  XCApp
//
//  Created by Alfian Losari on 08/10/24.
//

import Foundation
import Observation

@Observable class ViewModel {
    
    var username: String
    
    let analyticsManager: AnalyticsManagerInterface
    let databaseManager: DatabaseManagerInterface
    let networkManager: NetworkManagerInterface
    let remoteConfig: RemoteConfigInterface
    
    var user: User?
    var source: String = "default"
    var number: Int = 0
    
    init(userName: String, analyticsManager: AnalyticsManagerInterface, databaseManager: DatabaseManagerInterface, networkManager: NetworkManagerInterface, remoteConfig: RemoteConfigInterface) {
        self.username = userName
        self.analyticsManager = analyticsManager
        self.databaseManager = databaseManager
        self.networkManager = networkManager
        self.remoteConfig = remoteConfig
    }
    
    func onAppear() async {
        if remoteConfig.shouldFetchUserOnViewAppear,
           let user = try? await networkManager.fetchUser(username: username) {
            self.user = user
            analyticsManager.trackDidFetchUser(user)
        }
    }
    
    func saveButtonTapped() {
        analyticsManager.trackSaveButtonDidTapped(source: source)
        databaseManager.saveNumber(number)
    }
    
}
