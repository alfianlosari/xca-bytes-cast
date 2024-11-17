//
//  CircleImage.swift
//  LiveElectionTutorial
//
//  Created by Alfian Losari on 17/11/24.
//

import SwiftUI

struct CircleImage: View {
    
    let imageName: String?
    let bgColor: Color
    var size: CGSize = .init(width: 40, height: 40)
    
    var body: some View {
        Image(imageName ?? "")
            .resizable()
            .background(bgColor)
            .clipShape(Circle())
            .frame(width: size.width, height: size.height)
    }
    
}
#Preview {
    CircleImage(imageName: nil, bgColor: .red)
}
