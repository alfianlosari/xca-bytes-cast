//
//  ViewModel.swift
//  LiveElectionTutorial
//
//  Created by Alfian Losari on 08/11/24.
//

import Foundation
import ActivityKit
import SwiftUI
import Observation
import FirebaseFirestore

@Observable
@MainActor class ViewModel {
    
    let db = Firestore.firestore()
    var elections = [Election]()
    
    func listenToLiveElectionCollection() {
        db.collection("elections")
            .addSnapshotListener { snapshot, error in
                guard let snapshot else {
                    print("Error fetching snapshot: \(error?.localizedDescription ?? "error")")
                    return
                }
                let docs = snapshot.documents
                let elections: [Election] = docs.compactMap {
                    guard var election = try? $0.data(as: Election.self) else {
                        return nil
                    }
                    election.isLiveActivityRegistered = Activity<ElectionWidgetAttributes>.activities.contains(where: { $0.id == election.id })
                    return election
                    
                }
                
                withAnimation {
                    self.elections = elections
                }
            }
        
    }
    
    
    func startLiveActivity(election: Election, channelId: String) {
        guard ActivityAuthorizationInfo().frequentPushesEnabled
        else { return }
        do {
            let activityAttributes = ElectionWidgetAttributes(id: election.id)
            let activity = try Activity.request(attributes: activityAttributes, content: .init(state: .init(aName: election.aName, bName: election.bName, aCount: election.aCount, bCount: election.bCount, aPercent: election.aPercent, bPercent: election.bPercent, aImageName: election.aImageName, bImageName: election.bImageName), staleDate: nil), pushType: .channel(channelId))
            print("Requested a live activity \(String(describing: activity.id))")
            guard let index = self.elections.firstIndex(of: election) else { return }
            self.elections[index].isLiveActivityRegistered = true
        } catch {
            print("Error requesting live activity \(error.localizedDescription)")
        }
    }

        
}

