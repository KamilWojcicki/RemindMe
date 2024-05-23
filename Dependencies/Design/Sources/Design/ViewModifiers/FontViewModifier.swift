//
//  File.swift
//
//
//  Created by Kamil Wójcicki on 23/05/2024.
//

import Foundation
import SwiftUI

struct FontViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.size15Default)
            .opacity(0.5)
    }
}

extension View {
    public func withOpacityFont() -> some View {
        modifier(FontViewModifier())
    }
}
