//
//  View+Extension.swift
//
//
//  Created by Kamil Wójcicki on 08/04/2024.
//

import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
}
