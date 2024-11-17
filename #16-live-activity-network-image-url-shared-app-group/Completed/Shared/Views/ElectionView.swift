//
//  ElectionView.swift
//  LiveElectionTutorial
//
//  Created by Alfian Losari on 08/11/24.
//

import SwiftUI

struct ElectionView<CircleView: View>: View {
    
    let election: ElectionType
    let aCircleView: () -> CircleView
    let bCircleView: () -> CircleView
    
    
    init(election: ElectionType,
         @ViewBuilder aCircleView: @escaping () -> CircleView,
         @ViewBuilder bCircleView: @escaping () -> CircleView) {
        self.election = election
        self.aCircleView = aCircleView
        self.bCircleView = bCircleView
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                aCircleView()
                Text("\(election.aCount)")
                    .font(.title)
                Spacer()
                Text("\(election.bCount)")
                    .font(.title)
                bCircleView()
            }
            
            CustomProgressView(leftValue: election.aPercent, rightValue: election.bPercent)
            
            HStack {
                Text(election.aName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(election.bName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    List {
        ElectionView(election: ElectionWidgetAttributes.ContentState(aName: "Kamala Harris", bName: "Donald Trump", aCount: 226, bCount: 295, aPercent: 0.4, bPercent: 0.55),
                     aCircleView: {
            CircleImage(image: Image(uiImage: .init(named: "kamalaharris") ?? .init()), bgColor: .blue)
        }, bCircleView: {
            CircleImage(image: Image(uiImage: .init(named: "donaldtrump") ?? .init()), bgColor: .red)
        })
    }
}
