//
//  ContentView.swift
//  Webview demo
//
//  Created by 卓同学 on 2025/7/11.
//

import SwiftUI
import WebKit

struct ContentView: View {
//    @State private var currentURL = URL(string: "https://developer.apple.com/")!
//    @State private var currentURL = URL(string: "https://www.apple.com/ipad-air/")!
    @State private var currentURL = URL(string: "https://m.youtube.com/feed/trending?bp=6gQJRkVleHBsb3Jl")!
    @State private var webView: WKWebView = WKWebView()
    @State private var isLoading = false
    @State private var canGoForward = false
    @State private var canGoBack = false
    
    // 新增的滑动方向状态变量
    @State private var isScrollingUp = false
    @State private var isScrollingDown = false

    @State private var barState: BottomBarState = .collapse
    @State private var barHeight: CGFloat = BottomBarState.collapse.height

    var body: some View {
        ZStack {
            WebViewWithControls(
                url: currentURL,
                isLoading: $isLoading,
                canGoBack: $canGoBack,
                canGoForward: $canGoForward,
                webView: $webView,
                isScrollingUp: $isScrollingUp,
                isScrollingDown: $isScrollingDown
            )
            .id("aaa")
            .padding(.bottom, barHeight)
            VStack(spacing: 0) {
                Rectangle().fill(.white)
                    .frame(height: 62)
                    .ignoresSafeArea(edges: .top)
                Spacer()
                bottomBar
            }
        }
        .onChange(of: isScrollingUp) { _, newValue in
            if newValue {
                print("页面正在向上滑动")
                if barState != .minimal {
                    withAnimation(.easeOut(duration: 0.15),  {
                        barState = .minimal
                        barHeight = barState.height
                    })
                }
            }
        }
        .onChange(of: isScrollingDown) { _, newValue in
            if newValue {
                print("页面正在向下滑动")
                if barState != .collapse {
                    withAnimation(.easeOut(duration: 0.15),  {
                        barState = .collapse
                        barHeight = barState.height
                    })
                }
            }
        }
    }
    
    @ViewBuilder
    private var bottomBar: some View {
        VStack {
            if barState == .minimal {
                BottomBarMinimalView()
                    .padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16))
            } else {
                BottomBarToolView(state: barState)
            }
        }
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
            return 60 + 8
        case .collapse:
            return 44 + 24
        case .minimal:
            return 18 + 8
        }
    }
}

struct BottomBarToolView: View {
    let state: BottomBarState
    
    var body: some View {
        VStack(spacing: 0) {
            if state == .collapse {
                HStack(spacing: 0) {
                    Button {
                        
                    } label: {
                        Image(.close)
                    }
                    Spacer()
                    Capsule()
                        .stroke(.gray1, lineWidth: 1)
                        .frame(width: 104)
                        .overlay {
                            HStack(spacing: 8) {
                                Button {
                                    
                                } label: {
                                    Image(.icBack)
                                }
                                Button {
                                    
                                } label: {
                                    Image(.icForward)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 4)
                        }
                    Spacer()
                    Button {
                        
                    } label: {
                        Image(.icTrans)
                    }
                    Spacer()
                    Button {
                        
                    } label: {
                       Circle()
                            .stroke(.gray1, lineWidth: 1)
                            .frame(width: 28)
                            .overlay {
                                Image(.icUp)
                            }
                    }
                }
                .frame(height: 44)
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 16, trailing: 16))
            } else {
                
            }
        }
    }
}

struct BottomBarMinimalView: View {
    var body: some View {
        HStack {
            Spacer()
            Text("m.youtube.com")
                .font(.system(size: 14))
                .foregroundStyle(.gray3)
            Spacer()
        }
        .frame(height: 18)
    }
}

#Preview {
    ContentView()
}

#Preview("BottomBar") {
    VStack(spacing: 20) {
        BottomBarToolView(state: .collapse)
        
        BottomBarMinimalView()
    }
}
