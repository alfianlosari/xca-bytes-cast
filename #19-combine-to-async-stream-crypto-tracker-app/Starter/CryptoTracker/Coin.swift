//
//  Coin.swift
//  CryptoTracker
//
//  Created by Alfian Losari on 03/02/22.
//

import Foundation

struct Coin: Identifiable {
    var id: String { name }
    
    let name: String
    let value: Double
    
}
