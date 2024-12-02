//
//  TrackGeometryModifier.swift
//  Design
//
//  Created by Kamil Wójcicki on 01/12/2024.
//

import SwiftUI

struct TrackGeometryModifier: ViewModifier {
    @Binding var position: CGFloat
    
    func body(content: Content) -> some View {
        content.background(
            GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        position = geometry.frame(in: .global).minY
                    }
                    .onChange(of: geometry.frame(in: .global).minY) { newValue, _ in
                        position = newValue
                    }
            }
        )
    }
}

public extension View {
    func trackGeometry(position: Binding<CGFloat>) -> some View {
        self.modifier(TrackGeometryModifier(position: position))
    }
}
