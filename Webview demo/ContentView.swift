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

    @State private var barState: BottomBarState = .toolBar
    @State private var barHeight: CGFloat = BottomBarState.toolBar.height

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
                if barState != .toolBar {
                    withAnimation(.easeOut(duration: 0.15),  {
                        barState = .toolBar
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
                    .padding(EdgeInsets(top: 3, leading: 16, bottom: 3, trailing: 16))
                    .transition(.blurReplace)
            } else {
                BottomBarToolView(state: $barState)
                    .transition(.blurReplace)
            }
        }
        .overlay(alignment: .top) {
            Rectangle().fill(.gray1)
                .frame(height: 1)
        }
        .background(.regularMaterial) // 添加模糊玻璃效果背景
    
    }
}

enum BottomBarState {
    case toolBar
    case minimal
    
    var height: CGFloat {
        switch self {
        case .toolBar:
            return 44 + 24
        case .minimal:
            return 18 + 6
        }
    }
}

struct BottomBarToolView: View {
    @Binding var state: BottomBarState
    @State var isExpand: Bool = false
    @Namespace var namespace
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                if isExpand {
                    ZStack {
                        Capsule()
                            .fill(.gray3.opacity(0.1))
                        Capsule()
                            .stroke(.gray1, lineWidth: 1)
                    }
                    .matchedGeometryEffect(id: "capsule", in: namespace)
                    .padding(.trailing, 24)
                } else {
                    Button {
                        
                    } label: {
                        Image(.close)
                    }
                    Spacer()
                    Capsule()
                        .stroke(.gray1, lineWidth: 1)
                        .frame(width: 104)
                        .matchedGeometryEffect(id: "capsule", in: namespace)
                        .overlay {
                            historyButtons
                        }
                    Spacer()
                }
                transButton
                    .padding(.trailing, isExpand ? 24 : 0)
                if !isExpand {
                    Spacer()
                }
                stateButton
            }
            .frame(height: 44)
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 16, trailing: 16))
            if isExpand {
                HStack(spacing: 0) {
                    Button {
                        
                    } label: {
                        Image(.icFeedback)
                    }
                    Spacer()
                    Button {
                        
                    } label: {
                        Image(.icReload)
                    }
                    Spacer()
                    Button {
                        
                    } label: {
                        Image(.icMore)
                    }
                }
                .frame(height: 36)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 4, trailing: 16))
            }
        }
    }
    
    @ViewBuilder
    private var stateButton: some View {
        Button {
            withAnimation {
                isExpand.toggle()
            }
        } label: {
           Circle()
                .stroke(.gray1, lineWidth: 1)
                .frame(width: 28)
                .overlay {
                    Image(.icUp)
                        .rotationEffect(.degrees(isExpand ? 180 : 0))
                }
        }
    }
    
    @ViewBuilder
    private var transButton: some View {
        Button {
            
        } label: {
            Image(.icTrans)
                .shadow(color: .gray3.opacity(0.15), radius: 6, y: 3)
        }
    }
    
    @ViewBuilder
    private var historyButtons: some View {
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
    @Previewable @State var state: BottomBarState = .toolBar
    
    VStack(spacing: 20) {
        BottomBarToolView(state: $state)
        
        BottomBarToolView(state: $state, isExpand: true)

        BottomBarMinimalView()
    }
}
