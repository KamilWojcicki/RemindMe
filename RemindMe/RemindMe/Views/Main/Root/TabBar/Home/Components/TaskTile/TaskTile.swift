//
//  TaskTile.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 13/05/2024.
//

import Components
import Design
import SwiftUI
import Localizations

public struct TaskTile: View {
    @StateObject private var viewModel = TaskTileViewModel()
    let category: String
    let title: String
    var isEdited: ((Bool) -> Void)
    
    public init(category: String = "Category", title: String = "Title", isEdited: @escaping (Bool) -> Void) {
        self.category = category
        self.title = title
        self.isEdited = isEdited
    }
    
    public var body: some View {
        Rectangle()
            .fill(Colors.ghostWhite).opacity(0.1)
            .clipShape(.rect(cornerRadius: 30))
            .frame(height: 180)
            .overlay {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(category)
                            .font(.caption).opacity(0.7)
                        Text(title)
                            .font(.title).bold()
                    }
                    
                    Spacer()
                    
                    buildActionButtons
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(20)
                .foregroundStyle(Colors.ghostWhite)
            }
    }
}

#Preview {
    ZStack {
        Colors.background().ignoresSafeArea()
        TaskTile(category: "Category", title: "Title") { _ in }
    }
}

extension TaskTile {
    private var buildActionButtons: some View {
        HStack(spacing: 50) {
            ForEach(ActionButton.ButtonType.allCases, id: \.self) { button in
                if button != .history || viewModel.isDone {
                    ActionButton(
                        button: button,
                        image: button == .done && viewModel.isDone ? "\(button.image).fill" : button.image,
                        foregroundColor: button == .done && viewModel.isDone ? Colors.mantis : Colors.ghostWhite) {
                            Task {
                                do {
                                    try await viewModel.buttonTapped(button)
                                    isEdited(viewModel.showEditTask)
                                } catch {
                                    print(error)
                                }
                            }
                        }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}
