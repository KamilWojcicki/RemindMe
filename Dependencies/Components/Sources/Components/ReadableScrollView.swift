//
//  ReadableScrollView.swift
//  Components
//
//  Created by Kamil Wójcicki on 25/09/2024.
//

import SwiftUI

public struct ReadableScrollView<Content>: View where Content: View {
    let axes: Axis.Set
    let content: () -> Content
    let onScroll: (CGFloat) -> Void
    
    public init(axes: Axis.Set = .vertical, content: @escaping () -> Content, onScroll: @escaping (CGFloat) -> Void) {
        self.axes = axes
        self.content = content
        self.onScroll = onScroll
    }
    
    public var body: some View {
        ScrollView(axes) {
            content()
                .background(
                    GeometryReader { proxy in
                        let position = (
                            axes == .vertical ?
                            proxy.frame(in: .named("scrollID")).origin.y :
                            proxy.frame(in: .named("scrollID")).origin.x
                        )
                        
                        Color.clear
                            .onChange(of: position) { position, _ in
                                onScroll(position)
                            }
                    }
                )
        }
        .coordinateSpace(.named("scrollID"))
        .scrollIndicators(.hidden)
    }
}

