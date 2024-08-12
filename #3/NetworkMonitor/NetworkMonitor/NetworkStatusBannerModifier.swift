//
//  NetworkStatusBannerModifier.swift
//  NetworkMonitor
//
//  Created by Alfian Losari on 11/08/24.
//

import SwiftUI

struct NetworkStatusBannerModifier: ViewModifier {
    
    @State private var networkMonitor = NetworkMonitor()
    @State private var showBanner = false

    func body(content: Content) -> some View {
        ZStack {
            content
            if showBanner {
                VStack {
                    HStack {
                        Image(systemName: networkMonitor.isReachable ? "network" : "network.slash")
                            .foregroundColor(.white)
                            .imageScale(.large)
                        
                        Text(networkMonitor.statusText)
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    
                    .foregroundColor(.white)
                    .padding()
                    .background(networkMonitor.isReachable ? Color.green : Color.red)
                    .cornerRadius(32)
                    .shadow(radius: 5)
                    .onTapGesture {
                        withAnimation {
                            showBanner = false
                        }
                    }
                    .transition(.move(edge: .top))
                    .animation(.easeInOut, value: showBanner)
                    
                    Spacer()
                }
                .padding()
            }
        }
        .onChange(of: networkMonitor.isReachable, { _, isReachable in
            showBanner = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showBanner = false
                }
            }
        })
        
    }
}

extension View {
    func networkStatusBanner() -> some View {
        self.modifier(NetworkStatusBannerModifier())
    }
}

