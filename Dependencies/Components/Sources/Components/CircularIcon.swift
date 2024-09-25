//
//  CircularIcon.swift
//
//
//  Created by Kamil Wójcicki on 17/08/2024.
//

import Design
import SwiftUI

public struct CircularIcon: View {
    let icon: Icon
    
    public init(icon: Icon) {
        self.icon = icon
    }
    
    public var body: some View {
        icon.symbol
            .resizable()
            .scaledToFit()
            .frame(width: 25, height: 25)
            .padding(8)
            .background(icon.circleColor)
            .clipShape(Circle())
    }
}

#Preview {
    CircularIcon(icon: .trayIcon)
}

public struct Icon {
    let symbol: Image
    let circleColor: Color
    
    public static let tapIcon = Icon(symbol: Icons.tap, circleColor: .blue.opacity(0.2))
    public static let dishIcon = Icon(symbol: Icons.dinner, circleColor: .brown)
    public static let trayIcon = Icon(symbol: Icons.tray, circleColor: .blue.opacity(0.2))
    public static let clipboardIcon = Icon(symbol: Icons.clipboard, circleColor: .yellow)
}
