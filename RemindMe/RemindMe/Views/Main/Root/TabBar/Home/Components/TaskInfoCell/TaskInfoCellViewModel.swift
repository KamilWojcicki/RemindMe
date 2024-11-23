//
//  TaskInfoCellViewModel.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 02/11/2024.
//

import DependencyInjection
import Foundation
import SwiftUI
import ToDoInterface
import Utilities

@MainActor
final class TaskInfoCellViewModel: ObservableObject {
    @Inject private var toDoManager: ToDoManagerInterface
    
    func updateTask(task: ToDo) async throws {
        var updatedToDo = task
        
        updatedToDo.isDone.toggle()
        
        let updates = compare(old: task, updated: updatedToDo)
        
        try await toDoManager.updateToDo(todo: task, data: updates)
    }
}
