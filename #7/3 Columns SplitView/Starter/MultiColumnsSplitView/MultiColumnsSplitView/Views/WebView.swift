import SwiftUI
import WebKit

// WebView for iOS and macOS
struct WebView: View {
    let url: URL
    
    var body: some View {
        WebViewRepresentable(url: url)
            .edgesIgnoringSafeArea(.all) // Full screen for both platforms
    }
}

#if os(iOS)
struct WebViewRepresentable: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

#elseif os(macOS)
struct WebViewRepresentable: NSViewRepresentable {
    let url: URL
    
    func makeNSView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        nsView.load(request)
    }
}
#endif
