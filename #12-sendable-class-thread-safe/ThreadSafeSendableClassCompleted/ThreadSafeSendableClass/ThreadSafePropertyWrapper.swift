//
//  ThreadSafe.swift
//  ThreadSafeSendableClass
//
//  Created by Alfian Losari on 16/10/24.
//

import Foundation

@propertyWrapper
class ThreadSafe<T: Sendable>: @unchecked Sendable {
    
    private var value: T
    private let queue = DispatchQueue(label: "com.xca.threadSafePropertyWrapper", attributes: .concurrent)
    
    init(_ value: T) {
        self.value = value
    }
    
    var wrappedValue: T {
        get {
            return queue.sync {
                return self.value
            }
        }
        
        set {
            queue.async(flags: .barrier) {
                self.value = newValue
            }
        }
    }
    
}
