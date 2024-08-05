//
//  OffsetKey.swift
//
//
//  Created by Kamil Wójcicki on 23/06/2024.
//

import SwiftUI

public struct OffsetKey: PreferenceKey {
    public static var defaultValue: CGFloat = 0
    public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
