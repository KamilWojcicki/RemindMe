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
    @Binding private var latestTask: ToDo?
    @Binding private var isDone: Bool
    @Binding private var isEdited: Bool
    
    var onButtonTapped: (ActionButton.ButtonType) async throws -> Void
    
    init(
        latestTask: Binding<ToDo?>,
        isDone: Binding<Bool>,
        isEdited: Binding<Bool>,
        onButtonTapped: @escaping (ActionButton.ButtonType) async throws -> Void
    ) {
        self._latestTask = latestTask
        self._isDone = isDone
        self._isEdited = isEdited
        self.onButtonTapped = onButtonTapped
    }
    
    public var body: some View {
        Rectangle()
            .fill(Colors.ghostWhite).opacity(0.1)
            .clipShape(.rect(cornerRadius: 30))
            .frame(height: 180)
            .overlay {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(latestTask?.category.rawValue ?? "Category")
                            .font(.caption).opacity(0.7)
                        Text(latestTask?.name ?? "Title")
                            .font(.title).bold()
                    }
                    
                    Spacer()
                    
                    buildActionButtons
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(20)
                .foregroundStyle(Colors.night)
                .overlay {
                    if latestTask == nil {
                        VStack {
                            Button {
                                router.navigate(to: .addTask())
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
        TaskTile(
            latestTask: .constant(
                ToDo(
                    category: .birthday,
                    name: "",
                    toDoDescription: "",
                    executedDate: Date(),
                    startExecutedTime: nil,
                    endExecutedTime: nil,
                    numbersOfReminders: 1
                )
            ),
            isDone: .constant(false),
            isEdited: .constant(false),
            onButtonTapped: { _ in }
        )
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
                        foregroundColor: button == .done && isDone ? Colors.mantis : Colors.night) {
                            Task {
                                do {
                                    try await onButtonTapped(button)
                                    if isEdited {
                                        router.navigate(to: .addTask(task: $latestTask))
                                    }
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
