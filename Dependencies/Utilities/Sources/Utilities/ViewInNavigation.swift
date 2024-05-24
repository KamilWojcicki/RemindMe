//
//  SwiftUIView.swift
//  
//
//  Created by Kamil Wójcicki on 23/05/2024.
//

import SwiftUI

struct ViewInNavigation: ViewModifier {
    func body(content: Content) -> some View {
        NavigationStack {
            content
        }
    }
}

extension View {
    public func withNavigationStack() -> some View {
        modifier(ViewInNavigation())
    }
}
