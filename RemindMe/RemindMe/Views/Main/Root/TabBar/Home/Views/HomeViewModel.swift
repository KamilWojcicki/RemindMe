//
//  HomeViewModel.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 13/05/2024.
//

import Components
import DependencyInjection
import Foundation
import SwiftUI
import ToDoInterface

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var isDone: Bool = false
    @Published var isEdited: Bool = false
    @Published var latestToDo: ToDo? = nil
    @Inject private var toDoManager: ToDoManagerInterface
    
    private var timer: Timer?
    
    func updateToDoCategory(to category: ToDoInterface.Category) {
        toDoManager.updateCategory(newCategory: category)
    }
    
    func buttonTapped(_ type: ActionButton.ButtonType) async throws {
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
    
    func getLatestTask() {
        Task {
            do {
                self.latestToDo = try await toDoManager.getLatestToDo()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func archiveExpiredToDo() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            Task {
                do {
                    try await self.toDoManager.archiveExpiredToDos()
                    await self.getLatestTask()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func markAsDone() async throws {
        
        guard let latestToDo = latestToDo else { return }
        
        let data: [String : Any] = [
            ToDo.CodingKeys.id.rawValue : latestToDo.id,
            ToDo.CodingKeys.isDone.rawValue : true
        ]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            if self?.isDone == true {
                Task {
                    try await self?.toDoManager.updateToDo(data: data)
                    try await self?.addToArchive()
                    withAnimation(.interactiveSpring) {
                        self?.isDone = false
                    }
                }
            }
        }
        
        withAnimation(.interactiveSpring) {
            isDone.toggle()
        }
    }
    
    private func editTask() async throws {
        isEdited.toggle()
    }
    
    private func deleteTask() async throws {
        guard let latestToDo = latestToDo else { return }
        try await toDoManager.deleteToDo(primaryKey: latestToDo.id)
        getLatestTask()
    }
    
    private func addToArchive() async throws {
        guard let latestToDo = latestToDo else { return }
        try await toDoManager.archiveToDo(primaryKey: latestToDo.id)
        
        getLatestTask()
    }
}

