//
//  CoinListViewModel.swift
//  CryptoTracker
//
//  Created by Alfian Losari on 03/02/22.
//

import Foundation
import SwiftUI

@MainActor
@Observable class CoinListViewModel {
    
    let coinTypes: [CoinType]
    private(set) var coinDictionary = [String: Coin]()
    private(set) var statusText: String = ""
    private(set) var statusColor: Color = .red
    
    private let service: CoinCapPriceAsyncStreamService
    
    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.currencyCode = "USD"
        return formatter
    }()
    
    init(coinTypes: [CoinType] = CoinType.allCases, service: CoinCapPriceAsyncStreamService = .init()) {
        self.coinTypes = coinTypes.sorted { $0.description < $1.description }
        self.service = service
        self.service.connect()
        self.service.startMonitorNetworkConnectivity()
    }
    
    func listenToStream() {
        Task {
            let coinDictStream = service.coinDictionaryStream
            let connectionStateStream = service.connectionStateStream
            for await (coinDict, isConnected) in coinDictStream.combineLatest(with: connectionStateStream) {
                self.updateView(coinDict: coinDict, isConnected: isConnected)
            }
        }
    }
    
    func updateView(coinDict: [String: Coin], isConnected: Bool) {
        self.coinDictionary = coinDict
        if isConnected {
            self.statusText = "Connected to WebSocket Server\nRealtime Data by CoinCap.io"
        } else {
            self.statusText = "Disconnected"
        }
        self.statusColor = isConnected ? .green : .red
    }
    
    func valueText(for coinType: CoinType) -> String {
        if let coin = self.coinDictionary[coinType.rawValue],
           let value = self.currencyFormatter.string(from: NSNumber(value: coin.value)) {
            return value
        } else {
            return "-"
        }
     }
    
}
