//
//  ContentView.swift
//  Webview demo
//
//  Created by 卓同学 on 2025/7/11.
//

import SwiftUI
import WebKit

struct ContentView: View {
    @State private var currentURL = URL(string: "https://www.apple.com/ipad-air/")!
//    @State private var currentURL = URL(string: "https://www.youtube.com/feed/trending?bp=6gQJRkVleHBsb3Jl")!
    @State private var webView: WKWebView = WKWebView()
    @State private var isLoading = false
    @State private var canGoForward = false
    @State private var canGoBack = false

    @State private var barState: BottomBarState = .collapse
    @State private var barHeight: CGFloat = 44 + 8

    var body: some View {
        ZStack {
            WebViewWithControls(
                url: currentURL,
                isLoading: $isLoading,
                canGoBack: $canGoBack,
                canGoForward: $canGoForward,
                webView: $webView,
                contentInsetHeight: $barHeight
            )
            .padding(.bottom, barHeight)
            VStack {
                Rectangle().fill(.white)
                    .frame(height: 62)
                    .ignoresSafeArea(edges: .top)
                Spacer()
                bottomBar
            }
        }
    }
    
    @ViewBuilder
    private var bottomBar: some View {
        VStack {
            if barState == .minimal {
                BottomBarMinimalView()
            } else {
                HStack {
                    Spacer()
                    Text("Hello, world!")
                    Spacer()
                }
                .frame(height: 44)
            }
        }
        .padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16))
        .background(.regularMaterial) // 添加模糊玻璃效果背景
    }
}

enum BottomBarState {
    case expand
    case collapse
    case minimal
    
    var height: CGFloat {
        switch self {
        case .expand:
            return 60
        case .collapse:
            return 44
        case .minimal:
            return 22
        }
    }
}

struct BottomBarMinimalView: View {
    var body: some View {
        HStack {
            Text("developer.apple.com")
                .font(.system(size: 14))
                .foregroundStyle(.gray3)
        }
    }
}

#Preview {
    ContentView()
}

#Preview("BottomBar") {
    VStack {
        BottomBarMinimalView()
    }
}
