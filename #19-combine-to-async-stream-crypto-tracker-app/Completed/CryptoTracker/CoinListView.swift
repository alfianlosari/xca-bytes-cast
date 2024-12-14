//
//  CoinListView.swift
//  CryptoTracker
//
//  Created by Alfian Losari on 15/12/24.
//

import SwiftUI

struct CoinListView: View {
    
    @State var viewModel = CoinListViewModel()
    
    var body: some View {
        List {
            Section {
                HStack(spacing: 8) {
                    Image(systemName: "circle.fill")
                        .foregroundColor(viewModel.statusColor)
                    Text(viewModel.statusText)
                }
                .font(.subheadline)
            }
            
            
            ForEach(viewModel.coinTypes) { coinType in
                HStack {
                    Text(coinType.description).font(.headline)
                    Spacer()
                    Text(viewModel.valueText(for: coinType))
                        .frame(alignment: .trailing)
                        .font(.body)
                }
            }
        }
        .navigationTitle("XCA Crypto Tracker")
        .onAppear {
            viewModel.listenToStream()
        }
    }
}

#Preview {
    NavigationStack {
        CoinListView()
    }
}
