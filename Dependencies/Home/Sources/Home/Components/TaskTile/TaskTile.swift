//
//  TaskTile.swift
//
//
//  Created by Kamil Wójcicki on 02/05/2024.
//

import SwiftUI
import Design

public struct TaskTile: View {
    public enum ButtonType: String, CaseIterable {
        case done
        case edit
        case delete
        
        var description: String {
            switch self {
            case .done:
                "Done"
            case .edit:
                "Edit"
            case .delete:
                "Delete"
            }
        }
        
        var image: String {
            switch self {
            case .done:
                "checkmark.seal"
            case .edit:
                "pencil.and.list.clipboard"
            case .delete:
                "minus.circle"
            }
        }
    }
    
    @StateObject private var viewModel = TaskTileViewModel()
    let category: String
    let title: String
    
    public init(category: String, title: String) {
        self.category = category
        self.title = title
    }
    
    public var body: some View {
        Rectangle()
            .background(.ultraThinMaterial).opacity(0.5)
            .clipShape(.rect(cornerRadius: 30))
            .frame(height: 180)
            .overlay {
                VStack(alignment: .leading) {
                    VStack(spacing: 8) {
                        Text(category)
                            .font(.caption).opacity(0.7)
                        Text(title)
                            .font(.title).bold()
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 50) {

                        ForEach(ButtonType.allCases, id: \.self) { button in
                            buildActionButton(image: button.image, title: button.description, button: button)
                        }
                        
                        if viewModel.isDone {
                            buildActionButton(image: "heart.fill", title: "test") {
                                viewModel.addToArchive()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
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
        TaskTile(category: "Category", title: "Title")
    }
    
}

extension TaskTile {
    private func buildActionButton(image: String, title: String, button: ButtonType? = nil, action: (() -> Void)? = nil) -> some View {
        Button {
            Task {
                do {
                    guard let button = button else { return }
                    try await viewModel.buttonTapped(button)
                    action?()
                } catch {
                    print(error)
                }
                    
            }
        } label: {
            VStack(spacing: 5) {
                Image(systemName: button == .done && viewModel.isDone ? "\(image).fill" : image)
                    
                Text(title)
                    .font(.footnote)
            }
            .foregroundStyle(button == .done && viewModel.isDone ? Color.green : Colors.ghostWhite)
        }
    }
}
