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
    
    func updateToDoCategory(to category: Categories, using secViewModel: TabBarViewModel) {
            secViewModel.toDoCategory = category
        }
    
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
    
    func getLatestTask() async {
        do {
            self.latestToDo = try await toDoManager.getLatestToDo()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func markAsDone() async throws {
        
        guard let latestToDo = latestToDo else { return }
        
        let data: [String : Any] = [
            ToDo.CodingKeys.id.rawValue : latestToDo.id,
            ToDo.CodingKeys.isDone.rawValue : true
        ]
        
        try await toDoManager.updateToDo(data: data)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
                Task {
                    try await self?.addToArchive()
                    withAnimation(.interactiveSpring) {
                        self?.isDone = false
                    }
                    
                }
            }
        
        withAnimation(.interactiveSpring) {
            isDone.toggle()
        }
    }

    private func editTask() async throws {
//        showEditTask.toggle()
    }

    private func deleteTask() async throws {
        try await toDoManager.deleteToDo(primaryKey: latestToDo?.id ?? "")
        await getLatestTask()
    }
    
    func addToArchive() async throws {
        
        guard let latestToDo = latestToDo else { return }
        try await toDoManager.archiveToDo(primaryKey: latestToDo.id)
        
        await getLatestTask()
    }
}
