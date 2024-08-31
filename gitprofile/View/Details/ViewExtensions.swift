//
//  ViewExtensions.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 8/30/24.
//

import SwiftUI

public extension View {
    
    func onVisibilityChange(proxy: GeometryProxy, perform action: @escaping (Bool)->Void)-> some View {
        modifier(BecomingVisible(parentProxy: proxy, action: action))
    }
}

private struct BecomingVisible: ViewModifier {
    var parentProxy: GeometryProxy
    var action: ((Bool)->Void)
    
    @State var isVisible: Bool = false
    
    func checkVisible(proxy: GeometryProxy) {
        
        let parentFrame = self.parentProxy.frame(in: .global)
        let childFrame = proxy.frame(in: .global)
        
        let isVisibleNow = parentFrame.intersects(childFrame)
        
        if (self.isVisible != isVisibleNow) {
            self.isVisible = isVisibleNow
            self.action(isVisibleNow)
        }
    }

    func body(content: Content) -> some View {
        content.overlay {
            GeometryReader { proxy in
                Color.clear
                    .onAppear() {
                        self.checkVisible(proxy: proxy)
                    }
                    .onChange(of: proxy.frame(in: .global)) {
                        self.checkVisible(proxy: proxy)
                    }
            }
        }
    }
}
