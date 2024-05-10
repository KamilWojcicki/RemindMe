//
//  TaskTileViewModel.swift
//  
//
//  Created by Kamil Wójcicki on 02/05/2024.
//

import Components
import DependencyInjection
import Foundation
import SwiftUI
import ToDoInterface

@MainActor
public final class TaskTileViewModel: ObservableObject {
    
    @Published var isDone: Bool = false
    @Published var showEditTask: Bool = false
    @Published var latestToDo: ToDo? = nil
    @Inject private var toDoManager: ToDoManagerInterface
    
    public func buttonTapped(_ type: ActionButton.ButtonType) async throws {
        switch type {
        case .done:
            try await markAsDone()
        case .edit:
            try await editTask()
        case .delete:
            try await deleteTask()
        case .history:
            try await addToArchive()
        }
    }
    
    private func getLatestTask() async throws {
        self.latestToDo = try await toDoManager.getLatestToDo()
    }
    
    private func markAsDone() async throws {
        //action
        withAnimation(.interactiveSpring) {
            isDone.toggle()
        }
    }

    private func editTask() async throws {
        showEditTask.toggle()
    }

    private func deleteTask() async throws {
        try await toDoManager.deleteToDo(primaryKey: latestToDo?.id ?? "")
    }
    
    func addToArchive() async throws {
        //action
    }
}


