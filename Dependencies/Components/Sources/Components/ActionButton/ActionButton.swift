//
//  ActionButton.swift
//
//
//  Created by Kamil Wójcicki on 03/05/2024.
//

import Design
import SwiftUI

struct ActionButton: View {
    public enum ButtonType: String, CaseIterable {
        case done = "Done"
        case edit = "Edit"
        case delete = "Delete"
        case history = "History"
        
        private var image: String {
            switch self {
            case .done:
                "checkmark.seal"
            case .edit:
                "pencil.and.list.clipboard"
            case .delete:
                "minus.circle"
            case .history:
                "doc.badge.clock"
            }
        }
    }
    private let button: ButtonType
    
    public init(button: ButtonType) {
        self.button = button
    }
    
    let image: String
    let title: String
    let foregroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack(spacing: 5) {
                Image(systemName: image)
                
                Text(title)
                    .font(.footnote)
            }
            .foregroundStyle(foregroundColor)
        }
    }
}

#Preview {
    ActionButton(image: <#String#>, title: <#String#>, foregroundColor: <#Color#>, button: .done, action: <#() -> Void#>)
}


//extension TaskTile {
//    private func buildActionButton(image: String, title: String, button: ButtonType? = nil) -> some View {
//        Button {
//            Task {
//                do {
//                    guard let button = button else { return }
//                    try await viewModel.buttonTapped(button)
//                    isEdited(viewModel.showEditTask)
//                } catch {
//                    print(error)
//                }
//            }
//        } label: {
//            VStack(spacing: 5) {
//                Image(systemName: button == .done && viewModel.isDone ? "\(image).fill" : image)
//                
//                Text(title)
//                    .font(.footnote)
//            }
//            .foregroundStyle(button == .done && viewModel.isDone ? Color.green : Colors.ghostWhite)
//        }
//    }
//}
