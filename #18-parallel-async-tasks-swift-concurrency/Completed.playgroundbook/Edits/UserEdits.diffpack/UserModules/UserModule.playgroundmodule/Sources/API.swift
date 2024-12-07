
import Foundation

struct API {
    
    func fetchUserProfile(userId: Int) async throws -> UserProfile {
        if userId == 2 {
            throw NSError(domain: "fetchUserProfileError", code: 1, userInfo: nil)
        }
        try await Task.sleep(for: .seconds((1...2).randomElement()!))
        return .init(name: "Alfian Losari")
    }
    
    func fetchUserScore(userId: Int) async throws -> Int {
        if userId == 2 {
            throw NSError(domain: "fetchUserScoreError", code: 1, userInfo: nil)
        }
        try await Task.sleep(for: .seconds((1...2).randomElement()!))
        return (10000...100000).randomElement()!
    }
    
    func fetchAccount(accountNo: Int) async throws -> Account {
        if accountNo == 6 {
            throw NSError(domain: "fetchAccountError", code: 1, userInfo: nil)
        }
        try await Task.sleep(for: .seconds((1...2).randomElement()!))
        return Account(
            number: accountNo,
            balance: Double((10000...100000).randomElement()!),
            type: ["Saving", "Current", "Checking", "Deposit"].randomElement()!)
    }
    
    func sendNotification(userId: Int) async throws {
        if userId == 2 {
            throw NSError(domain: "sendNotificationError", code: 1, userInfo: nil)
        }
        try await Task.sleep(for: .seconds((1...2).randomElement()!))
    }

}

