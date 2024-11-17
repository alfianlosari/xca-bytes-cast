//
//  AppGroupFileManager.swift
//  LiveElectionTutorial
//
//  Created by Alfian Losari on 17/11/24.
//

import Foundation

class AppGroupFileManager {
    let appGroupID: String
    let directory: URL
    
    init(appGroupID: String = "group.alfianlosari.LiveScore") throws {
        self.appGroupID = appGroupID
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) else {
            throw NSError(domain: "ManagerError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to find container URL for app group ID: \(appGroupID)"])
        }
        
        self.directory = containerURL.appendingPathComponent("images")
        try FileManager.default.createDirectory(at: self.directory, withIntermediateDirectories: true, attributes: nil)
    }
    
    func save(data: Data, to relativePath: String) throws {
        let fileURL = directory.appendingPathComponent(relativePath)
        let directoryURL = fileURL.deletingLastPathComponent()
                
        // Ensure the directory exists
        if !FileManager.default.fileExists(atPath: directoryURL.path) {
            try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
        }
        
        
        
        do {
            try data.write(to: fileURL)
        } catch {
            throw NSError(domain: "ManagerError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to save data to file: \(relativePath). Error: \(error.localizedDescription)"])
        }
    }
    
    func load(from relativePath: String) -> Data? {
        let fileURL = directory.appendingPathComponent(relativePath)
        return try? Data(contentsOf: fileURL)
    }
    
    func delete(from relativePath: String) throws {
        let fileURL = directory.appendingPathComponent(relativePath)
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            throw NSError(domain: "ManagerError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Failed to delete file: \(relativePath). Error: \(error.localizedDescription)"])
        }
    }
}
