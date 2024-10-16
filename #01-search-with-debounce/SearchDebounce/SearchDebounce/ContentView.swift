//
//  ContentView.swift
//  ObservableXCombine
//
//  Created by Alfian Losari on 30/07/24.
//

import SwiftUI

@MainActor
struct ContentView: View {
    
    @State var vm = ViewModel()
    
    var body: some View {
        List(vm.state.data ?? [], id: \.self) {
            Text($0)
        }
        .overlay {
            if vm.state.isLoading {
                ProgressView("Searching \"\(vm.searchText)\"")
            }
            
            if vm.isSearchNotFound {
                Text("Results not found for\n\"\(vm.searchText)\"")
                    .multilineTextAlignment(.center)
            }
        }
        .searchable(text: $vm.searchText, prompt: "Search")
        .navigationTitle("Observable X Combine Demo")
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}

