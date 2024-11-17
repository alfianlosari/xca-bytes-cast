//
//  ContentView.swift
//  LiveElectionTutorial
//
//  Created by Alfian Losari on 08/11/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var vm = ViewModel()
    
    var body: some View {
        NavigationStack {
            List(vm.elections) { election in
                VStack(spacing: 8) {
                    ElectionView(election: election,
                                 aCircleView: {
                        AsyncCircleImage(url: election.aImageUrl, bgColor: .blue)
                    }, bCircleView: {
                        AsyncCircleImage(url: election.bImageUrl, bgColor: .red)
                    })
                    if let channelId = election.channelId, !(election.isLiveActivityRegistered ?? false) {
                        Button("Get Real-Time Live Activity Updates") {
                            vm.startLiveActivity(election: election, channelId: channelId)
                        }.buttonStyle(.borderedProminent)
                    }
                }
            }
            .navigationTitle("Live Elections")
            .onAppear { vm.listenToLiveElectionCollection() }
        }
    }
}

#Preview {
    ContentView()
}
