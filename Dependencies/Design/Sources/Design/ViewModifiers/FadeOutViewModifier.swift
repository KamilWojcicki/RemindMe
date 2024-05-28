//
//  File.swift
//
//
//  Created by Kamil Wójcicki on 28/05/2024.
//

import Foundation
import SwiftUI

struct FadeOutViewModifier: ViewModifier {
    
    let topFadeLength: CGFloat
    let bottomFadeLength: CGFloat
    
    func body(content: Content) -> some View {
        content
            .mask(
                VStack(spacing: 0) {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black.opacity(0), Color.black]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: topFadeLength)
                    
                    Rectangle().fill(Color.black)
                    
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black, Color.black.opacity(0)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: bottomFadeLength)
                }
            )
    }
}

extension View {
    public func withFadeOut(topFadeLength: CGFloat = 50, bottomFadeLength: CGFloat = 50) -> some View {
        modifier(FadeOutViewModifier(topFadeLength: topFadeLength, bottomFadeLength: bottomFadeLength))
    }
}
