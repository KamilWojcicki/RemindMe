//
//  TaskDetailViewModel.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 30/10/2024.
//

import DependencyInjection
import Foundation
import SwiftUI
import ToDoInterface
import Utilities

@MainActor
final class TaskDetailViewModel: ObservableObject {
    enum State: Equatable {
        case loaded
        case error(String)
    }
    
    @Published var state: State = .loaded
    @Published var showFullImage: Bool = false
    @Published var isErrorPresented: Bool = false
    @Inject private var toDoManager: ToDoManagerInterface
    
    func updateSubtask(task: ToDo, subtask: SubToDo) async throws {
        var updatedSubToDo = subtask
        updatedSubToDo.isCompleted.toggle()
        let updates = compare(old: subtask, updated: updatedSubToDo)

        try await toDoManager.updateSubToDo(task: task, subToDo: subtask, data: updates)
        
        state = .loaded
    }
    
    func handleError(error: Error) {
        withAnimation {
            if let localizedError = error as? LocalizedError {
                state = .error(localizedError.localizedDescription)
            } else {
                state = .error(AppError.unexpectedError(error.localizedDescription).errorDescription ?? error.localizedDescription)
            }
        }
    }
    
    func handleDismissErrorView() {
        withAnimation {
            state = .loaded
        }
    }
    
    func onImageTapAction(task: ToDo) {
        withAnimation {
            guard task.image != nil else { return }
            showFullImage.toggle()
        }
    }
}
