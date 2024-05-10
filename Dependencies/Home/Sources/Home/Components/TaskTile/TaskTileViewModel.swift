//
//  TaskTileViewModel.swift
//  
//
//  Created by Kamil Wójcicki on 02/05/2024.
//

import Foundation

public final class TaskTileViewModel: ObservableObject {
    @Published var isDone: Bool = false
    
    public func buttonTapped(_ type: TaskTile.ButtonType) async throws {
        switch type {
        case .done:
            try await markAsDone()
        case .edit:
            try await editTask()
        case .delete:
            try await deleteTask()
        }
    }
    
    private func markAsDone() async throws{
        //action
        isDone.toggle()
    }

    private func editTask() async throws{
        //action
    }

    private func deleteTask() async throws{
        //action
    }
    
    func addToArchive() {
        
    }
}


