//
//  ToDoInfoCellViewModel.swift
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
final class ToDoInfoCellViewModel: ObservableObject {
    @Inject private var toDoManager: ToDoManagerInterface
    
    func updateToDo(toDo: ToDo) async throws {
        var updatedToDo = toDo
        
        updatedToDo.isDone.toggle()
        
        let updates = compare(old: toDo, updated: updatedToDo)
        
        try await toDoManager.updateToDo(toDo: toDo, data: updates)
    }
}
