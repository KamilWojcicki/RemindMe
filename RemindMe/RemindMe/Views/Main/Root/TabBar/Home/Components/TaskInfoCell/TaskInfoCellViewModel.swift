//
//  TaskInfoCellViewModel.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 02/11/2024.
//

import DependencyInjection
import Foundation
import ToDoInterface
import Utilities

final class TaskInfoCellViewModel: ObservableObject {
    @Inject private var toDoManager: ToDoManagerInterface
    
    
    func updateTask(task: ToDo) {
        Task {
            do {
                var updatedToDo = task
                
                updatedToDo.isDone.toggle()
                
                let updates = compare(old: task, updated: updatedToDo)
            
                try await toDoManager.updateToDo(todo: task, data: updates)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
