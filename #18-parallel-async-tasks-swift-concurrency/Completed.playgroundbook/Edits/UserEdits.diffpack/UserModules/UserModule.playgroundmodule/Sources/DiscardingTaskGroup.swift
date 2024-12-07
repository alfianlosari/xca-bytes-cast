


import Foundation

public struct DiscardingTaskGroupPlayground {
    
    static let api = API()
    
    public static func run() async {
        print("DiscardingTaskGroup Playground:")
        let userIds = [1,2,3,4,5,6]
        
        await withDiscardingTaskGroup { group in
            for userId in userIds {
                group.addTask { try? await api.sendNotification(userId: userId) }
            }
        }
        
        print("Completed")
    }
}
