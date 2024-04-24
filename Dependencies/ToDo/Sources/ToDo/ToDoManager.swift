//
//  ToDoManager.swift
//
//
//  Created by Kamil Wójcicki on 18/04/2024.
//

import DependencyInjection
import Foundation
import LocalDatabaseInterface
import ToDoInterface

final class ToDoManager: ToDoManagerInterface {
    @Inject private var localDatabaseManager: LocalDatabaseManagerInterface
    
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
}
