//
//  CircularIcon.swift
//
//
//  Created by Kamil Wójcicki on 17/08/2024.
//

import Design
import SwiftUI
import ToDoInterface

public struct CircularIcon: View {
    let icon: Icon
    
    public init(icon: Icon) {
        self.icon = icon
    }
    
    public var body: some View {
        if let uiImage = UIImage(data: icon.symbol ?? Data()) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .padding(8)
                .background(icon.circleColor)
                .clipShape(Circle())
        }
    }
}

#Preview {
    CircularIcon(icon: .trayIcon)
}
