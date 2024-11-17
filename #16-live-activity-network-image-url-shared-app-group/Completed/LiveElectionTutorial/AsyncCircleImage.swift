//
//  AsyncCircleImage.swift
//  LiveElectionTutorial
//
//  Created by Alfian Losari on 17/11/24.
//

import CachedAsyncImage
import SwiftUI

struct AsyncCircleImage: View {
    
    let url: String?
    let bgColor: Color
    var size: CGSize = .init(width: 40, height: 40)
    
    var body: some View {
        if let url {
            CachedAsyncImage(url: URL(string: url)) { phase in
                switch phase {
                case .success(let image):
                    CircleImage(image: image, bgColor: bgColor, size: size)
                default:
                    CircleImage(image: nil, bgColor: bgColor, size: size)
                }
            }
        } else {
            CircleImage(image: nil, bgColor: bgColor, size: size)
        }
    }
}

#Preview {
    AsyncCircleImage(url: "https://imagizer.imageshack.com/img923/732/0xV2bC.jpg", bgColor: .blue)

}
