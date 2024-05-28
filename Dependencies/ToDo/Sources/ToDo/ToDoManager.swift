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
    
    func getLatestToDo() async throws -> ToDo? {
        var toDos: [ToDo] = []
        toDos = try await readActiveToDos()
        
        var latestToDo: ToDo? = nil
        var latestExecutionTime: Date? = nil
        
        for toDo in toDos {
            if latestExecutionTime == nil || toDo.executedTime > latestExecutionTime ?? Date() {
                latestExecutionTime = toDo.executedTime
                latestToDo = toDo
            }
        }
        
        return latestToDo
    }
    
    func archiveToDo(primaryKey: String) async throws {
        let data: [String : Any] = [
            ToDo.CodingKeys.id.rawValue : primaryKey,
            ToDo.CodingKeys.isArchived.rawValue : true
        ]
        
        try await updateToDo(data: data)
    }
    
    func readActiveToDos() async throws -> [ToDo] {
        var activeToDos: [ToDo] = []
        var allToDos: [ToDo] = []
        allToDos = try await readAllToDos()
        
        for toDo in allToDos {
            if toDo.isArchived == false {
                activeToDos.append(toDo)
            }
        }
        
        return activeToDos
    }
    
    func readArchiveToDos() async throws -> [ToDo] {
        var archiveToDos: [ToDo] = []
        var allToDos: [ToDo] = []
        allToDos = try await readAllToDos()
        
        for toDo in allToDos {
            if toDo.isArchived {
                archiveToDos.append(toDo)
            }
        }
        
        return archiveToDos
    }
}
