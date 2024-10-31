//
//  ClockType.swift
//  TaskTimer
//
//  Created by Alfian Losari on 31/10/24.
//

import Foundation

enum ClockType: String, CaseIterable, Identifiable {
    case suspending = "Suspending"
    case continuous = "Continuous"
    var id: String { self.rawValue }
}
