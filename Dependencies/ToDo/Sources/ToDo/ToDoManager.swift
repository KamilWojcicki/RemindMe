//
//  ToDoManager.swift
//
//
//  Created by Kamil Wójcicki on 18/04/2024.
//

import Combine
import DependencyInjection
import Foundation
import LocalDatabaseInterface
import SwiftUI
import ToDoInterface

final class ToDoManager: ToDoManagerInterface {
    @Inject private var localDatabaseManager: LocalDatabaseManagerInterface
    
    let updatedCategory = PassthroughSubject<ToDoInterface.Category?, Never>()
    
    private var category: ToDoInterface.Category? {
        didSet {
            updatedCategory.send(category)
        }
    }
    
    func createToDo(todo: ToDo) async throws {
        try await localDatabaseManager.create(todo)
    }
    
    func readToDo(primaryKey: String) async throws -> ToDo {
        try await localDatabaseManager.read(type: ToDo.self, primaryKey: primaryKey)
    }
    
    func readAllToDos() async throws -> [ToDo] {
        try await localDatabaseManager.read()
    }
    
    func updateToDo(data: [String : Any]) async throws {
        try await localDatabaseManager.update(type: ToDo.self, withUpdates: data)
    }
    
    func deleteToDo(primaryKey: String) async throws {
        try await localDatabaseManager.delete(type: ToDo.self, primaryKey: primaryKey)
    }
    
    func deleteAllToDos() async throws {
        try await localDatabaseManager.deleteAll()
    }
    
    func getLatestToDo() async throws -> ToDo? {
        let toDos = try await readActiveToDos()
        return toDos.max(by: { $0.executedDate < $1.executedDate })
    }
    
    func archiveToDo(primaryKey: String) async throws {
        let data: [String : Any] = [
            ToDo.CodingKeys.id.rawValue : primaryKey,
            ToDo.CodingKeys.isArchived.rawValue : true
        ]
        
        try await updateToDo(data: data)
    }
    
    func readActiveToDos() async throws -> [ToDo] {
        let allToDos = try await readAllToDos()
        return allToDos.filter { !$0.isArchived }
    }
    
    func readArchiveToDos() async throws -> [ToDo] {
        let allToDos = try await readAllToDos()
        return allToDos.filter { $0.isArchived }
    }
}

//CATEGORY
extension ToDoManager {
    func updateCategory(newCategory: ToDoInterface.Category?) {
        self.category = newCategory
    }
}

//DELETE TODO IF DATE IS EXPIRED
extension ToDoManager {
    func archiveExpiredToDos() async throws {
        var toDos = try await readActiveToDos()
        let currentDate = Date()

        for toDo in toDos {
            guard let startExecutedTime = toDo.startExecutedTime else { return }
            if startExecutedTime < currentDate {
                try await archiveToDo(primaryKey: toDo.id)
                withAnimation {
                    toDos.removeAll { $0.id == toDo.id }
                }
            }
        }
    }
}
