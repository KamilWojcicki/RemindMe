//
//  ConfirmButton.swift
//
//
//  Created by Kamil Wójcicki on 27/04/2024.
//

import Design
import SwiftUI

public struct ConfirmButton: View {
    
    public enum `ButtonRole`: Hashable {
        
        case cancel
        case confirm
        case destructive
    }
    
    private let title: LocalizedStringKey
    private let role: ButtonRole
    private let action: () -> Void
    
    private var fillColor: Color {
        switch role {
        case .cancel:
            Colors.color
        case .confirm:
            Colors.blue
        case .destructive:
            Colors.imperialRed
        }
    }
    
    public init(title: LocalizedStringKey, role: ButtonRole, action: @escaping () -> Void) {
        self.title = title
        self.role = role
        self.action = action
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            Rectangle()
                .fill(fillColor)
                .frame(height: 70)
                .clipShape(.rect(cornerRadius: 15))
                .overlay {
                    Text(title)
                        .foregroundStyle(Colors.ghostWhite)
                        .font(.title2)
                }
        }
    }
}

#Preview {
    ConfirmButton(title: "test", role: .cancel, action: {})
}
