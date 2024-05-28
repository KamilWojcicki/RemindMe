//
//  TaskTile.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 13/05/2024.
//

import Components
import Design
import Localizations
import Navigation
import SwiftUI
import ToDoInterface

public struct TaskTile: View {
    @EnvironmentObject private var router: Router<Routes>
    @StateObject private var viewModel = TaskTileViewModel()
    @Binding private var isDone: Bool
    @Binding private var latestTask: ToDo?
    let category: String
    let title: String
    var onButtonTapped: (ActionButton.ButtonType) async throws -> Void
    var isEdited: ((Bool) -> Void)
    
    init(
        category: String = "Category",
        title: String = "Title",
        isDone: Binding<Bool>,
        latestTask: Binding<ToDo?>,
        onButtonTapped: @escaping (ActionButton.ButtonType) async throws -> Void,
        isEdited: @escaping (Bool) -> Void
    ) {
        self.category = category
        self.title = title
        self._isDone = isDone
        self._latestTask = latestTask
        self.onButtonTapped = onButtonTapped
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
                .overlay {
                    if latestTask == nil {
                        VStack {
                            Button {
                                router.navigate(to: .addTask)
                            } label: {
                                Image(systemName: Symbols.plusCircle)
                                    .font(.system(size: 100))
                                    .foregroundStyle(Colors.ghostWhite.opacity(0.8))
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Colors.vistaBlue.opacity(0.7))
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                    }
                }
            }
    }
}

#Preview {
    ZStack {
        Colors.background().ignoresSafeArea()
        TaskTile(isDone: .constant(false), latestTask: .constant(ToDo(category: .birthday, name: "", toDoDescription: "", executedTime: Date(), numbersOfReminders: 1)), onButtonTapped: { _ in }) { _ in }
    }
}

extension TaskTile {
    private var buildActionButtons: some View {
        HStack(spacing: 50) {
            ForEach(ActionButton.ButtonType.allCases, id: \.self) { button in
                if button != .history || isDone {
                    ActionButton(
                        button: button,
                        image: button == .done && isDone ? "\(button.image).fill" : button.image,
                        foregroundColor: button == .done && isDone ? Colors.mantis : Colors.ghostWhite) {
                            Task {
                                do {
                                    try await onButtonTapped(button)
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
