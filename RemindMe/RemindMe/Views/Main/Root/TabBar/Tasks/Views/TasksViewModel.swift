//
//  TasksViewModel.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 13/05/2024.
//

import DependencyInjection
import Foundation
import ToDoInterface

@MainActor
final class TasksViewModel: ObservableObject {
    @Inject private var toDoManager: ToDoManagerInterface
    @Published var tasks: [ToDo] = []
    
    func getAllTasks() async {
        do {
            self.tasks = try await toDoManager.readAllToDos()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
}
