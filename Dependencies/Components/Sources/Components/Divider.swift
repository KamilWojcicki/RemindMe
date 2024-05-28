//
//  Divider.swift
//
//
//  Created by Kamil Wójcicki on 23/05/2024.
//

import Design
import SwiftUI

public struct OpacityDivider: View {
    
    public init() { }
    
    public var body: some View {
        Divider()
            .frame(height: 1)
            .background(Colors.ghostWhite.opacity(0.5))
    }
}

#Preview {
    Divider()
}
