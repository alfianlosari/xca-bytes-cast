///
/// @Generated by Mockolo
///



import Foundation
@testable import XCApp


class AnalyticsManagerInterfaceMock: AnalyticsManagerInterface {
    init() { }


    private(set) var trackSaveButtonDidTappedCallCount = 0
    var trackSaveButtonDidTappedArgValues = [String]()
    var trackSaveButtonDidTappedHandler: ((String) -> ())?
    func trackSaveButtonDidTapped(source: String)  {
        trackSaveButtonDidTappedCallCount += 1
        trackSaveButtonDidTappedArgValues.append(source)
        if let trackSaveButtonDidTappedHandler = trackSaveButtonDidTappedHandler {
            trackSaveButtonDidTappedHandler(source)
        }
        
    }

    private(set) var trackDidFetchUserCallCount = 0
    var trackDidFetchUserArgValues = [User]()
    var trackDidFetchUserHandler: ((User) -> ())?
    func trackDidFetchUser(_ user: User)  {
        trackDidFetchUserCallCount += 1
        trackDidFetchUserArgValues.append(user)
        if let trackDidFetchUserHandler = trackDidFetchUserHandler {
            trackDidFetchUserHandler(user)
        }
        
    }
}

class DatabaseManagerInterfaceMock: DatabaseManagerInterface {
    init() { }


    private(set) var saveNumberCallCount = 0
    var saveNumberArgValues = [Int]()
    var saveNumberHandler: ((Int) -> ())?
    func saveNumber(_ number: Int)  {
        saveNumberCallCount += 1
        saveNumberArgValues.append(number)
        if let saveNumberHandler = saveNumberHandler {
            saveNumberHandler(number)
        }
        
    }
}

class NetworkManagerInterfaceMock: NetworkManagerInterface {
    init() { }


    private(set) var fetchUserCallCount = 0
    var fetchUserArgValues = [String]()
    var fetchUserHandler: ((String) async throws -> (User))?
    func fetchUser(username: String) async throws -> User {
        fetchUserCallCount += 1
        fetchUserArgValues.append(username)
        if let fetchUserHandler = fetchUserHandler {
            return try await fetchUserHandler(username)
        }
        fatalError("fetchUserHandler returns can't have a default value thus its handler must be set")
    }
}

class RemoteConfigInterfaceMock: RemoteConfigInterface {
    init() { }
    init(shouldFetchUserOnViewAppear: Bool = false) {
        self.shouldFetchUserOnViewAppear = shouldFetchUserOnViewAppear
    }


    private(set) var shouldFetchUserOnViewAppearSetCallCount = 0
    var shouldFetchUserOnViewAppear: Bool = false { didSet { shouldFetchUserOnViewAppearSetCallCount += 1 } }
}
