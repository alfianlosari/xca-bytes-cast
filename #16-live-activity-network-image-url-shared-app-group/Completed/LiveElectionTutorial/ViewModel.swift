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
import CachedAsyncImage

@Observable
@MainActor class ViewModel {
    
    let db = Firestore.firestore()
    var elections = [Election]()
    
    let fileManager: AppGroupFileManager? = {
        try? AppGroupFileManager()
    }()
    
    let urlCache = URLCache.shared
    
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
        Task {
            do {
                async let aImage: () = storeImageInAppGroup(urlString: election.aImageUrl, relativePath: "\(election.id)/a")
                async let bImage: () = storeImageInAppGroup(urlString: election.bImageUrl, relativePath: "\(election.id)/b")
                _ = await [aImage, bImage]
                
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
    
    func storeImageInAppGroup(urlString: String?, relativePath: String) async {
         guard let fileManager,
               let urlString,
               let url = URL(string: urlString)
         else { return }
         var data: Data?
         if let cachedData = urlCache.cachedResponse(for: URLRequest(url: url))?.data {
             data = cachedData
         } else if let downloadedData = try? await download(from: url) {
             data = downloadedData
         }

         guard let data, let imageData = UIImage(data: data)?.resized(toWidth: 40)?.pngData() else { return }
         do {
             try fileManager.save(data: imageData, to: relativePath)
         } catch {
             print("Error saving image to app group: \(error)")
         }
     }
     
     
     func download(from url: URL) async throws -> Data? {
         let (data, response) = try await URLSession.shared.data(from: url)
         guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
             print("Failed to download image from \(url.absoluteString)")
             throw URLError(.badServerResponse)
         }
         return data
     }

        
}


extension UIImage {
    /// Resizes the image to a specific width while maintaining its aspect ratio.
    ///
    /// - Parameter width: The desired width for the resized image.
    /// - Returns: A resized `UIImage` instance, or `nil` if resizing fails.
    func resized(toWidth width: CGFloat) -> UIImage? {
        // Calculate the aspect ratio and the new height
        let aspectRatio = size.height / size.width
        let newHeight = width * aspectRatio
        
        // Create a new size for the image
        let newSize = CGSize(width: width, height: newHeight)
        
        // Start a graphics context
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        
        // Draw the image in the resized rectangle
        draw(in: CGRect(origin: .zero, size: newSize))
        
        // Get the resized image from the context
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
