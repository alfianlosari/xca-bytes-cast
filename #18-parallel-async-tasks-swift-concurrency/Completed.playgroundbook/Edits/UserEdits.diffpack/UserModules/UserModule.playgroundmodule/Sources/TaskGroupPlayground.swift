

import Foundation

public struct TaskGroupPlayground {
    
    static let api = API()
    
    public static func run() async {
        print("TaskGroup Playground:")
        
        let accounts = await withTaskGroup(of: Account?.self) { group in
            let accountNumbers = [1,2,3,4,5,6]
            
            for accountNumber in accountNumbers {
                group.addTask {
                    try? await self.api.fetchAccount(accountNo: accountNumber)
                }
            }
            
            var accounts = [Account]()
            for await result in group {
                if let result {
                    accounts.append(result)
                }
            }
            
            return accounts
            
        }
        print(accounts)
    }
    
    public static func run2() async {
        print("TaskGroup Playground with next:")
        
        let accounts = await withTaskGroup(of: Account?.self) { group in
            let accountNumbers = [1,2,3,4,5,6]
            
            for accountNumber in accountNumbers {
                group.addTask {
                    try? await self.api.fetchAccount(accountNo: accountNumber)
                }
            }
            
            guard let first = await group.next() else {
                group.cancelAll()
                return []
            }
            
            guard let second = await group.next() else {
                group.cancelAll()
                return [first]
            }
            
            group.cancelAll()
            return [first, second]
        }
        print(accounts)
    }
}
