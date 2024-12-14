//
//  CryptoTrackerApp.swift
//  CryptoTracker
//
//  Created by Alfian Losari on 14/12/24.
//

import SwiftUI

@main
struct CryptoTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                CoinListView()
            }
            #if os(macOS)
            .frame(minWidth: 512, maxWidth: 512, minHeight: 480)            
            #endif
        }
        #if os(macOS)
        .windowResizability(.contentSize)
        #endif
    }
}
