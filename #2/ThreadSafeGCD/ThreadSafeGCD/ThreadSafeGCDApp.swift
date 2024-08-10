//
//  ThreadSafeGCDApp.swift
//  ThreadSafeGCD
//
//  Created by Alfian Losari on 10/08/24.
//

import SwiftUI
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    @ThreadSafe([1,2,3,4,5,6]) var arr
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    
    func simulateConcurrentWrite() {
        let queue = DispatchQueue(label: "com.xca.queue", attributes: .concurrent)
        
        queue.async {
            self.arr.append(1)
        }
        
        queue.async {
            self.arr.append(3)
        }
        
        queue.async {
            self.arr.append(5)
        }
        
        queue.async {
            self.arr.append(7)
        }
        
        queue.async {
            self.arr.append(9)
        }
        
    }
}



@main
struct ThreadSafePropertyApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            Text("Crash Simulation")
                .onAppear {
                    delegate.simulateConcurrentWrite()
                }
        }
    }
}
