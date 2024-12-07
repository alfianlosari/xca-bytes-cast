
import Foundation

struct UserProfile {
    let name: String
}

struct Account: Identifiable {
    let id = UUID()
    let number: Int
    let balance: Double
    let type: String
}

struct HomeScreenData {
    let userProfile: UserProfile
    let userScore: Int
}
