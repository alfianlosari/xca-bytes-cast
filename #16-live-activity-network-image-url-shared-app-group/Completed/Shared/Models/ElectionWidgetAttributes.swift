//
//  ElectionWidgetAttributes.swift
//  LiveElectionTutorial
//
//  Created by Alfian Losari on 08/11/24.
//

import ActivityKit
import Foundation

struct ElectionWidgetAttributes: ActivityAttributes {
    public struct ContentState: ElectionType, Codable, Hashable {
        var aName: String
        var bName: String
        var aCount: Int
        var bCount: Int
        var aPercent: Double
        var bPercent: Double
        
        var aImageName: String?
        var bImageName: String?
    }
    
    let id: String
}

