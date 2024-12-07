



import Foundation

public struct ThrowingDiscardingTaskGroupPlayground {
    
    static let api = API()
    
    public static func run() async {
        print("ThrowingDiscardingTaskGroup Playground:")
        let userIds = [1,2,3,4,5,6]
        
        do {
            try await withThrowingDiscardingTaskGroup { group in
                for userId in userIds {
                    group.addTask { try await api.sendNotification(userId: userId) }
                }
            }
        } catch {
            if error is CancellationError {
                print("Cancelled")
                return
            }
            print("\(error)")
        }
        
     
        print("Completed")
    }
}
