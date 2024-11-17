//
//  ElectionLiveActivity.swift
//  MyWidgetExtension
//
//  Created by Alfian Losari on 08/11/24.
//

import WidgetKit
import Foundation
import SwiftUI

struct ElectionWidgetLiveActivity: Widget {
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ElectionWidgetAttributes.self) { context in
            ElectionView(election: context.state)
                .padding()
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    ElectionView(election: context.state)
                        .padding(.bottom)
                }
            } compactLeading: {
                HStack {
                    CircleImage(imageName: context.state.aImageName, bgColor: .blue, size: .init(width: 20, height: 20))
                    Text("\(context.state.aCount)")
                        .foregroundStyle(.blue)
                    Spacer()
                }
                
            } compactTrailing: {
                HStack {
                    Spacer()
                    Text("\(context.state.bCount)")
                        .foregroundStyle(.red)
                    CircleImage(imageName: context.state.bImageName, bgColor: .red, size: .init(width: 20, height: 20))
                }
            } minimal: {}
        }
        
    }
    
}


extension ElectionWidgetAttributes {
    fileprivate static var preview: ElectionWidgetAttributes {
        ElectionWidgetAttributes(id: UUID().uuidString)
    }
}

extension ElectionWidgetAttributes.ContentState {
    fileprivate static var sample: ElectionWidgetAttributes.ContentState {
        .init(
            aName: "Kamala",
            bName: "Donald",
            aCount: 226,
            bCount: 295,
            aPercent: 0.4,
            bPercent: 0.55,
            aImageName: "kamalaharris",
            bImageName: "donaldtrump")
    }
}

#Preview("Notification", as: .content, using: ElectionWidgetAttributes.preview) {
    ElectionWidgetLiveActivity()
} contentStates: {
    ElectionWidgetAttributes.ContentState.sample
}

#Preview("Dynamic Island Expanded", as: .dynamicIsland(.expanded), using: ElectionWidgetAttributes.preview) {
    ElectionWidgetLiveActivity()
} contentStates: {
    ElectionWidgetAttributes.ContentState.sample
}


#Preview("Dynamic Island Compact", as: .dynamicIsland(.compact), using: ElectionWidgetAttributes.preview) {
    ElectionWidgetLiveActivity()
} contentStates: {
    ElectionWidgetAttributes.ContentState.sample
}
