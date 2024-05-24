//
//  File.swift
//
//
//  Created by Kamil Wójcicki on 23/05/2024.
//

import Design
import Foundation
import SwiftUI

struct FontViewModifier: ViewModifier {
    
    let foregroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .font(.size15Default)
            .foregroundStyle(foregroundColor)
            .opacity(0.5)
    }
}

extension View {
    public func withOpacityFont(foregroundColor: Color = Colors.night) -> some View {
        modifier(FontViewModifier(foregroundColor: foregroundColor))
    }
}
