//
//  NetworkCacheApp.swift
//  NetworkCache
//
//  Created by Alfian Losari on 05/09/24.
//

import SwiftUI

@main
struct NetworkCacheApp: App {
    
    @State var cache = NetworkCache<PostResponse>()
        
    var body: some Scene {
        WindowGroup {
            PostListView(store: .init(cache: cache))
        }
    }
}

