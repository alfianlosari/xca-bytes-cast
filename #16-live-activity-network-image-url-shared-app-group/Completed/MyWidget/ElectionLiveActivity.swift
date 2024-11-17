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
    
    let fileManager: AppGroupFileManager? = {
        try? AppGroupFileManager()
    }()
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ElectionWidgetAttributes.self) { context in
            ElectionView(election: context.state,
                         aCircleView: {
                CircleImage(image: image(key: "a", electionId: context.attributes.id), bgColor: .blue)
            },
                         bCircleView: {
                CircleImage(image: image(key: "b", electionId: context.attributes.id), bgColor: .red)
            })
                .padding()
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    ElectionView(election: context.state,
                                 aCircleView: {
                        CircleImage(image: image(key: "a", electionId: context.attributes.id), bgColor: .blue)
                    },
                                 bCircleView: {
                        CircleImage(image: image(key: "b", electionId: context.attributes.id), bgColor: .red)
                    })
                    .padding(.bottom)
                }
            } compactLeading: {
                HStack {
                    CircleImage(image: image(key: "a", electionId: context.attributes.id), bgColor: .blue, size: .init(width: 20, height: 20))
                    Text("\(context.state.aCount)")
                        .foregroundStyle(.blue)
                    Spacer()
                }
                
            } compactTrailing: {
                HStack {
                    Spacer()
                    Text("\(context.state.bCount)")
                        .foregroundStyle(.red)
                    CircleImage(image: image(key: "b", electionId: context.attributes.id), bgColor: .red, size: .init(width: 20, height: 20))
                }
            } minimal: {}
        }
        
    }
    
    func image(key: String, electionId: String) -> Image? {
        guard let data = fileManager?.load(from: "\(electionId)/\(key)"),
              let image = UIImage(data: data) else { return nil }
        return Image(uiImage: image)
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
