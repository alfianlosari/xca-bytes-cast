
import Foundation

public struct AsyncLetPlayground {
    
    static let api = API()
    
    public static func run() async {
        print("TaskGroup Playground:")
        do {
            async let userProfileAsyncFetch = api.fetchUserProfile(userId: 1)
            async let userScoreAsyncFetch = api.fetchUserScore(userId: 1)
            let (userProfile, userScore) = try await (userProfileAsyncFetch, userScoreAsyncFetch)
            try Task.checkCancellation()
            print(HomeScreenData(userProfile: userProfile, userScore: userScore))
        } catch {
            if error is CancellationError {
                print("Cancelled")
                return
            }
            print("\(error)")
        }
    }
}
