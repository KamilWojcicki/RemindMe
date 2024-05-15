//
//  ActionButton.swift
//
//
//  Created by Kamil Wójcicki on 03/05/2024.
//

import Design
import SwiftUI

public struct ActionButton: View {
    public enum ButtonType: String, CaseIterable {
        case done = "Done"
        case edit = "Edit"
        case delete = "Delete"
        case history = "History"
        
        public var image: String {
            switch self {
            case .done:
                Symbols.checkmarkSeal
            case .edit:
                Symbols.pencilAndListClipboard
            case .delete:
                Symbols.minusCircle
            case .history:
                Symbols.docBadgeClock
            }
        }
    }
    
    private let button: ButtonType
    private let image: String
    private let foregroundColor: Color
    private let action: () -> Void
    
    public init(button: ButtonType, image: String, foregroundColor: Color, action: @escaping () -> Void) {
        self.button = button
        self.image = image
        self.foregroundColor = foregroundColor
        self.action = action
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            VStack(spacing: 5) {
                Image(systemName: image)
                
                Text(button.rawValue)
                    .font(.footnote)
            }
            .foregroundStyle(foregroundColor)
        }
    }
}

#Preview {
    ZStack {
        Colors.background().ignoresSafeArea()
        
        ActionButton(button: .done, image: "", foregroundColor: .red) {
            
        }
    }
    
}

