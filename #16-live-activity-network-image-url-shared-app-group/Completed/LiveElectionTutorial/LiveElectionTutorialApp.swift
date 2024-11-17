//
//  LiveElectionTutorialApp.swift
//  LiveElectionTutorial
//
//  Created by Alfian Losari on 08/11/24.
//

import ActivityKit
import FirebaseCore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    
    let fileManager: AppGroupFileManager? = {
        try? AppGroupFileManager()
    }()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        if let fileManager {
            let activeActivitiesElectionIds = Activity<ElectionWidgetAttributes>.activities.map {
                            $0.attributes.id }
            
            let appGroupDirElectionIds = fileManager.findAllExistingElectionsIds()
            let electionIdImageDirsToDelete = Set(appGroupDirElectionIds).subtracting(Set(activeActivitiesElectionIds))
            electionIdImageDirsToDelete.forEach { id in
                try? fileManager.delete(from: "\(id)")
            }
            
            Task {
                for try await activity in  Activity<ElectionWidgetAttributes>.activityUpdates {
                    if activity.activityState == .dismissed || activity .activityState == .ended {
                        try? fileManager.delete(from: "\(activity.attributes.id)")
                    }
                }
            }
        }
        
        return true
    }
}

extension AppGroupFileManager {

    func findAllExistingElectionsIds() -> [String] {
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            return contents.map { $0.lastPathComponent }
        } catch {
            print("Error reading contents of directory: \(error.localizedDescription)")
            return []
        }
    }
}


@main
struct LiveElectionTutorialApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
