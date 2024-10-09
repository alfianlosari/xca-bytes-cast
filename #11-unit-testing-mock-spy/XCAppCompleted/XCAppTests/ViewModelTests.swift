//
//  ViewModelTests.swift
//  XCAppTests
//
//  Created by Alfian Losari on 08/10/24.
//

import Foundation
import XCTest
@testable import XCApp

class ViewModelTests: XCTestCase {
    
    var sut: ViewModel!
    
    var analyticsManager: AnalyticsManagerInterfaceMock!
    var databaseManager: DatabaseManagerInterfaceMock!
    var networkManager: NetworkManagerInterfaceMock!
    var remoteConfig: RemoteConfigInterfaceMock!
    
    
    override func setUp() {
        analyticsManager = .init()
        databaseManager = .init()
        networkManager = .init()
        remoteConfig = .init()
        
        sut = .init(userName: "alfianlosari",
                    analyticsManager: analyticsManager,
                    databaseManager: databaseManager,
                    networkManager: networkManager,
                    remoteConfig: remoteConfig)
    }

    
    func testOnAppearWithRemoteConfigToFetchUserEnabled() async throws {
        sut.username = "alfianxca"
        remoteConfig.shouldFetchUserOnViewAppear = true
        networkManager.fetchUserHandler = { _ in User(id: "1234", username: "xca") }
        await sut.onAppear()
        XCTAssertEqual(networkManager.fetchUserCallCount, 1)
        XCTAssertEqual(networkManager.fetchUserArgValues.first, "alfianxca")
        XCTAssertEqual(sut.user?.id, "1234")
        XCTAssertEqual(sut.user?.username, "xca")
        XCTAssertEqual(analyticsManager.trackDidFetchUserCallCount, 1)
        XCTAssertEqual(analyticsManager.trackDidFetchUserArgValues.first?.id, "1234")
        XCTAssertEqual(analyticsManager.trackDidFetchUserArgValues.first?.username, "xca")
        
    }
    
    func testOnAppearWithRemoteConfigToFetchUserDisabled() async throws {
        remoteConfig.shouldFetchUserOnViewAppear = false
        await sut.onAppear()
        XCTAssertEqual(networkManager.fetchUserCallCount, 0)
        XCTAssertNil(sut.user)
        XCTAssertEqual(analyticsManager.trackDidFetchUserCallCount, 0)
    }
    
    func testSaveButtonDidTapped() {
        sut.source = "xca"
        sut.number = 10
        sut.saveButtonTapped()
        XCTAssertEqual(analyticsManager.trackSaveButtonDidTappedCallCount, 1)
        XCTAssertEqual(analyticsManager.trackSaveButtonDidTappedArgValues.first, "xca")
        XCTAssertEqual(databaseManager.saveNumberCallCount, 1)
        XCTAssertEqual(databaseManager.saveNumberArgValues.first, 10)
    }
 
}

