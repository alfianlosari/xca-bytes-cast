//
//  CustomProgressView.swift
//  LiveElectionTutorial
//
//  Created by Alfian Losari on 17/11/24.
//

import SwiftUI

struct CustomProgressView: View {
    var leftValue: CGFloat
    var rightValue: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            let leftWidth = min(totalWidth * (leftValue), totalWidth)
            let rightWidth = min(totalWidth * (rightValue), totalWidth)
            
            ZStack {
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: leftWidth, height: 10)
                        .cornerRadius(5, corners: [.topLeft, .bottomLeft])
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: totalWidth - leftWidth - rightWidth, height: 10)
                    
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: rightWidth, height: 10)
                        .cornerRadius(5, corners: [.topRight, .bottomRight])
                }
                
                Rectangle()
                    .fill(Color.black)
                    .frame(width: 1, height: 10)
                    .position(x: totalWidth / 2, y: 5)
            }
        }
        .frame(height: 10)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

#Preview {
    CustomProgressView(leftValue: 0.25, rightValue: 0.25)
}


