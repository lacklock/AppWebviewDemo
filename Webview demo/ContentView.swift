//
//  ContentView.swift
//  Webview demo
//
//  Created by 卓同学 on 2025/7/11.
//

import SwiftUI
import WebKit

struct ContentView: View {
    @State private var currentURL = URL(string: "https://developer.apple.com")!
    @State private var webView: WKWebView = WKWebView()
    @State private var isLoading = false
    @State private var canGoForward = false
    @State private var canGoBack = false
    
    var body: some View {
        ZStack {
            WebViewWithControls(
                url: currentURL,
                isLoading: $isLoading,
                canGoBack: $canGoBack,
                canGoForward: $canGoForward,
                webView: $webView
            )
            VStack {
                Spacer()
                bottomBar
            }
        }
    }
    
    @ViewBuilder
    private var bottomBar: some View {
        VStack {
            HStack {
                Spacer()
                Text("Hello, world!")
                Spacer()
            }
        }
        .frame(height: 44)
        .background(.ultraThinMaterial) // 添加模糊玻璃效果背景
    }
}

#Preview {
    ContentView()
}
