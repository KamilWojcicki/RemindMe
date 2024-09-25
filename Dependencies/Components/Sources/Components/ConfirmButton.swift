//
//  ConfirmButton.swift
//
//
//  Created by Kamil Wójcicki on 27/04/2024.
//

import Design
import SwiftUI

public struct ConfirmButton: View {
    
    private var title: LocalizedStringKey
    private var action: () -> Void
    
    public init(title: LocalizedStringKey, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            Rectangle()
                .fill(Colors.blue)
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
    ConfirmButton(title: "test", action: {})
}
