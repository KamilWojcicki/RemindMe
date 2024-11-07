//
//  TaskDetailViewModel.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 30/10/2024.
//

import DependencyInjection
import Foundation
import ToDoInterface
import Utilities

@MainActor
final class TaskDetailViewModel: ObservableObject {
    @Inject private var toDoManager: ToDoManagerInterface
    
    func updateSubtask(task: ToDo, subtask: SubToDo) async throws {
        var updatedSubToDo = subtask
        updatedSubToDo.isCompleted.toggle()
        let updates = compare(old: subtask, updated: updatedSubToDo)
        
        try await toDoManager.updateSubToDo(task: task, subToDo: subtask, data: updates)
    }
}
