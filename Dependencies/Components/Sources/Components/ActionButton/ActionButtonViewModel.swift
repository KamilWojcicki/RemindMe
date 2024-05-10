//
//  ActionButtonViewModel.swift
//
//
//  Created by Kamil Wójcicki on 03/05/2024.
//

import Foundation

@MainActor
public final class ActionButtonViewModel: ObservableObject {
    @Published public var isDone: Bool = false
    @Published public var showEditTask: Bool = false
    
    public init() { }
    
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
    
    private func markAsDone() async throws{
        //action
        isDone.toggle()
    }

    private func editTask() async throws{
        showEditTask.toggle()
    }

    private func deleteTask() async throws{
        //action
    }
    
    private func addToArchive() async throws {
        //action
    }
}
