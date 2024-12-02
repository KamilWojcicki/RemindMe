//
//  OnPreferenceChangeKeyModifier.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 02/12/2024.
//

import SwiftUI
import Utilities

struct OnPreferenceChangeKeyModifier: ViewModifier {
    let action: (CGFloat) -> Void
    
    func body(content: Content) -> some View {
        content
            .background {
                GeometryReader {
                    let minX = $0.frame(in: .global).minX
                    
                    Color.clear
                        .preference(key: OffsetKey.self, value: minX)
                        .onPreferenceChange(OffsetKey.self) { value in
                            action(value)
                        }
                }
            }
    }
}

extension View {
    func onPreferenceChangeKey(action: @escaping (CGFloat) -> Void) -> some View {
        modifier(OnPreferenceChangeKeyModifier(action: action))
    }
}
