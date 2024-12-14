//
//  CoinType.swift
//  CryptoTracker
//
//  Created by Alfian Losari on 03/02/22.
//

import Foundation

enum CoinType: String, Identifiable, CaseIterable {
    
    case bitcoin
    case binanceCoin = "binance-coin"
    case ethereum
    case monero
    case litecoin
    case dogecoin
    case stellar
    case iota
    case tron
    case neo
    case dash
    case zilliqa
    case digibyte
    case icon
    case verge
    case stratis
    
    var id: Self { self }
    var url: URL { URL(string: "https://coincap.io/assets/\(rawValue)")! }
    var description: String {
        switch self {
        case .binanceCoin: return "Binance Coin"
        default: return rawValue.capitalized
        }
    }
    
}
