//
//  Grabber.swift
//  Components
//
//  Created by Kamil Wójcicki on 30/11/2024.
//

import Design
import SwiftUI

public struct Grabber: View {
    
    public init() { }
    
    public var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Colors.night.opacity(0.5))
            .frame(width: 30, height: 3)
            .padding(.top)
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    Grabber()
}
