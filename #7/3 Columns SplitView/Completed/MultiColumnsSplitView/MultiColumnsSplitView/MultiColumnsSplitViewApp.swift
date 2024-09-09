//
//  MultiColumnsSplitViewApp.swift
//  MultiColumnsSplitView
//
//  Created by Alfian Losari on 09/09/24.
//

import SwiftUI

@main
struct MultiColumnsSplitViewApp: App {
    
    var navigationModel: NavigationModel
    
    init() {
        #if os(macOS) || os(visionOS)
        self.navigationModel = .init(columnVisibility: .all)
        #else
        self.navigationModel = .init(columnVisibility: .automatic)
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            MultiColumnSplitView()
                .environment(navigationModel)
        }
    }
}
