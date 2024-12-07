


import Foundation

public struct ThrowingTaskGroupPlayground {
    
    static let api = API()
    
    public static func run() async {
        print("ThrowingTaskGroup Playground:")
        let accountNumbers = [1,2,3,4,5,6]

        do {
            let accounts = try await withThrowingTaskGroup(of: Account.self) { group in                
                for accountNumber in accountNumbers {
                    group.addTask {
                        try await self.api.fetchAccount(accountNo: accountNumber)
                    }
                }
                
                var accounts = [Account]()
                for try await result in group {
                    accounts.append(result)
                }
                return accounts
            }
            print(accounts)
        } catch {
            if error is CancellationError {
                print("Cancelled")
                return
            }
            print("\(error)")
        }        
    }
    
    
     public static func run2() async {
         print("ThrowingTaskGroup Playground 2:")
         let accountNumbers = [1,2,3,4,5,6]

         do {
             let accounts = try await withThrowingTaskGroup(of: Account.self) { group in                 
                 for accountNumber in accountNumbers {
                     group.addTask {
                         try await self.api.fetchAccount(accountNo: accountNumber)
                     }
                 }
                 
                 var numberOfErrorThrown = 0
                 var accounts = [Account]()
                 while !group.isEmpty {
                     do {
                         if let account = try await group.next() {
                             accounts.append(account)
                         }
                     } catch {
                         numberOfErrorThrown += 1
                         if numberOfErrorThrown == 2 {
                             group.cancelAll()
                         }
                         print("Error: \(error)")
                     }
                 }
                 return accounts
             }
             print(accounts)
         } catch {
             if error is CancellationError {
                 print("Cancelled")
                 return
             }
             print("\(error)")
         }        
     }
}
