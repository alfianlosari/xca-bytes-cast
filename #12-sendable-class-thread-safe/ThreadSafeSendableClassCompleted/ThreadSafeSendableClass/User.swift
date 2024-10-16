//
//  User.swift
//  ThreadSafeSendableClass
//
//  Created by Alfian Losari on 16/10/24.
//

import Foundation

final class User: Sendable  {
    let id: String
    let username: String
    
    init(id: String, username: String) {
        self.id = id
        self.username = username
    }
}
