//
//  Election.swift
//  LiveElectionTutorial
//
//  Created by Alfian Losari on 08/11/24.
//

import Foundation

protocol ElectionType {
    var aName: String { get }
    var bName: String { get }
    
    var aCount: Int { get }
    var bCount: Int { get }
    var aPercent: Double { get }
    var bPercent: Double { get }
    
    var aImageName: String? { get }
    var bImageName: String? { get }
}

struct Election: ElectionType, Codable, Identifiable, Hashable {
    
    var id: String
    var aName: String
    var bName: String
    var aCount: Int
    var bCount: Int
    var aPercent: Double
    var bPercent: Double
    
    var aImageName: String?
    var bImageName: String?
    
    var aImageUrl: String?
    var bImageUrl: String?
    
    var channelId: String?

    var isLiveActivityRegistered: Bool? = false
    
}
