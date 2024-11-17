//
//  ElectionView.swift
//  LiveElectionTutorial
//
//  Created by Alfian Losari on 08/11/24.
//

import SwiftUI

struct ElectionView: View {
    
    let election: ElectionType
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                CircleImage(imageName: election.aImageName, bgColor: .blue)
                Text("\(election.aCount)")
                    .font(.title)
                Spacer()
                Text("\(election.bCount)")
                    .font(.title)
                CircleImage(imageName: election.bImageName, bgColor: .red)
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
        ElectionView(election: ElectionWidgetAttributes.ContentState(aName: "Kamala Harris", bName: "Donald Trump", aCount: 226, bCount: 295, aPercent: 0.4, bPercent: 0.55, aImageName: "kamalaharris", bImageName: "donaldtrump"))
    }
}
