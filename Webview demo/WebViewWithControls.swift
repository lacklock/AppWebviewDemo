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
    @Binding var isScrollingUp: Bool
    @Binding var isScrollingDown: Bool
    
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
        
        // 设置滚动代理来检测滑动方向
        webView.scrollView.delegate = context.coordinator
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        // 将webView实例传递给父视图
        DispatchQueue.main.async {
            self.webView = webView
        }
        
        if webView.url == nil {
            let request = URLRequest(url: url)
            webView.load(request)
        } else {
            // 使用更准确的URL比较方法
            if let webviewURL = webView.url,
               !areURLsEqual(webviewURL, url) {
                let request = URLRequest(url: url)
                webView.load(request)
            }
        }
    }
    
    // 添加URL比较辅助方法
    private func areURLsEqual(_ url1: URL, _ url2: URL) -> Bool {
        return url1.absoluteString == url2.absoluteString
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate, UIScrollViewDelegate {
        let parent: WebViewWithControls
        private var lastContentOffset: CGFloat = 0
        
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
        
        // MARK: - UIScrollViewDelegate
        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            lastContentOffset = scrollView.contentOffset.y
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let currentOffset = scrollView.contentOffset.y
            let offsetDifference = currentOffset - lastContentOffset
            print("offsetDifference: \(offsetDifference)")

            let threshold: CGFloat = 5.0
            
            if abs(offsetDifference) > threshold {
                DispatchQueue.main.async {
                    if offsetDifference > 0 {
                        self.parent.isScrollingUp = true
                        self.parent.isScrollingDown = false
                    } else {
                        self.parent.isScrollingUp = false
                        self.parent.isScrollingDown = true
                    }
                }
                lastContentOffset = currentOffset
            }
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            DispatchQueue.main.async {
                self.parent.isScrollingUp = false
                self.parent.isScrollingDown = false
            }
        }
        
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            // 如果没有减速，立即重置状态
            if !decelerate {
                DispatchQueue.main.async {
                    self.parent.isScrollingUp = false
                    self.parent.isScrollingDown = false
                }
            }
        }
    }
}
