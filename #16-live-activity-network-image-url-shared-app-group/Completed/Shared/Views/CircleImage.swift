//
//  CircleImage.swift
//  LiveElectionTutorial
//
//  Created by Alfian Losari on 17/11/24.
//

import SwiftUI

struct CircleImage: View {
    
    let image: Image?
    let bgColor: Color
    var size: CGSize = .init(width: 40, height: 40)
    
    var body: some View {
        if let image {
            image
            .resizable()
            .background(bgColor)
            .clipShape(Circle())
            .frame(width: size.width, height: size.height)
        } else {
            Circle()
                .foregroundStyle(bgColor)
                .frame(width: size.width, height: size.height)
        }
    }
    
}
#Preview {
    CircleImage(image: nil, bgColor: .red)
}
