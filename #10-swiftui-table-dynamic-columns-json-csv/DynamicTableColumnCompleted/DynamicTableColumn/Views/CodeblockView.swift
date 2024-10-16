import SwiftUI

struct CodeBlockView: View {
    
    let attributedString: AttributedString
    
    var body: some View {
        ScrollView {
            ScrollView(.horizontal, showsIndicators: true) {
                Text(attributedString)
                    .padding([.horizontal, .vertical], 16)
                    .textSelection(.enabled)
            }
        }
        .background(Color(red: 38/255, green: 38/255, blue: 38/255))
    }
}
