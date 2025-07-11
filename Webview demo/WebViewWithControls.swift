//
//  WebViewWithControls.swift
//  Webview demo
//
//  Created by Assistant on 2025/7/11.
//

import SwiftUI
import WebKit

// 完整功能的WebView，支持前进后退等操作
struct WebViewWithControls: UIViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool
    @Binding var canGoBack: Bool
    @Binding var canGoForward: Bool
    @Binding var webView: WKWebView
    
    @Binding var contentInsetHeight: CGFloat
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        
        // 配置WebView设置
        webView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        webView.configuration.allowsInlineMediaPlayback = true
        
        // 配置滚动视图，让内容可以延伸到底部栏下方
//        webView.scrollView.contentInsetAdjustmentBehavior = .never
//        webView.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: contentInsetHeight, right: 0)
//        webView.scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: contentInsetHeight, right: 0)
        webView.scrollView.clipsToBounds = false
        webView.clipsToBounds = false
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
//        if webView.scrollView.contentInset.bottom != self.contentInsetHeight {
//            webView.scrollView.contentInset.bottom = self.contentInsetHeight
//        }
        // 将webView实例传递给父视图
        DispatchQueue.main.async {
            self.webView = webView
        }
        
        // 只在URL改变时加载新页面
        if webView.url != url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: WebViewWithControls
        
        init(_ parent: WebViewWithControls) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            DispatchQueue.main.async {
                self.parent.isLoading = true
            }
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            DispatchQueue.main.async {
                self.parent.isLoading = false
                self.parent.canGoBack = webView.canGoBack
                self.parent.canGoForward = webView.canGoForward
            }
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            DispatchQueue.main.async {
                self.parent.isLoading = false
                print("页面加载失败: \(error.localizedDescription)")
            }
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            DispatchQueue.main.async {
                self.parent.isLoading = false
                print("页面加载失败: \(error.localizedDescription)")
            }
        }
    }
}
