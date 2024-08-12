//
//  ContentView.swift
//  NetworkMonitor
//
//  Created by Alfian Losari on 11/08/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var networkMonitor = NetworkMonitor()
        
    var body: some View {
        VStack(spacing: 20) {
            Text("XCA Network Monitor Demo")
                .font(.title)
            
            HStack {
                Circle()
                    .foregroundStyle(networkMonitor.isReachable ? .green : .red)
                    .frame(width: 20, height: 20)
                Text(networkMonitor.statusText)
            }
            
            Text("Network Status Monitor with NWPathMonitor")
                .multilineTextAlignment(.center)
            
            Text("Toggle Airplane Mode to trigger network reachability between connected and not connected")
                .multilineTextAlignment(.center)
            
        }
        .networkStatusBanner()
    }
}

#Preview {
    ContentView()
}

