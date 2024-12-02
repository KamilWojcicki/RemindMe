//
//  ToDoManager.swift
//
//
//  Created by Kamil Wójcicki on 18/04/2024.
//

import Combine
import DependencyInjection
import Design
import Foundation
import LocalDatabaseInterface
import SwiftUI
import ToDoInterface

final class ToDoManager: ToDoManagerInterface {
    @Inject private var localDatabaseManager: LocalDatabaseManagerInterface
    
    let updatedToDo = PassthroughSubject<ToDo?, Never>()
    let updatedToDos = PassthroughSubject<[ToDo], Never>()
    let updatedDoneToDosPercentage = PassthroughSubject<Double, Never>()
    let updatedCategorizedCounts = PassthroughSubject<[String: CategoryInfo], Never>()
    
    private var toDo: ToDo? {
        didSet {
            updatedToDo.send(toDo)
        }
    }
    
    private var toDos: [ToDo] = [] {
        didSet {
            updatedToDos.send(toDos)
        }
    }
    
    private var doneTaskPercentage: Double = 0 {
        didSet {
            updatedDoneToDosPercentage.send(doneTaskPercentage)
        }
    }
    
    private var categorizedCounts: [String: CategoryInfo] = [:] {
        didSet {
            updatedCategorizedCounts.send(categorizedCounts)
        }
    }
    
    func createToDo(toDo: ToDo) async throws {
        let newToDo = try await localDatabaseManager.create(toDo)
        
        toDos.append(newToDo)
    }
    
    func readToDo(primaryKey: String) async throws -> ToDo {
        try await localDatabaseManager.read(primaryKey: primaryKey)
    }
    
    func readAllToDos() async throws -> [ToDo] {
        self.toDos = try await localDatabaseManager.read()
        
        try await updateTaskStatistics()
        
        return toDos
    }
    
    func updateToDo(toDo: ToDo, data: [String: Any]) async throws {
        var updatedToDo = try await localDatabaseManager.update(object: toDo, withUpdates: data)
        
        let subToDoUpdates = [SubToDo.CodingKeys.isCompleted.rawValue: updatedToDo.isDone]
        
        for (index, subToDo) in updatedToDo.list.enumerated() {
            let updatedSubToDo = try await localDatabaseManager.update(object: subToDo, withUpdates: subToDoUpdates)
            updatedToDo.list[index] = updatedSubToDo
        }
        
        if let index = toDos.firstIndex(where: { $0.id == toDo.id }) {
            toDos[index] = updatedToDo
        }
        
        try await updateTaskStatistics()
    }
    
    func updateSubToDo(toDo: ToDo, subToDo: SubToDo, data: [String: Any]) async throws {
        let updatedSubToDo = try await localDatabaseManager.update(object: subToDo, withUpdates: data)

        var activeToDo = try await readToDo(primaryKey: toDo.id)
        
        if let index = activeToDo.list.firstIndex(where: { $0.id == subToDo.id }) {
            activeToDo.list[index] = updatedSubToDo
        }

        let areAllSubToDosCompleted = activeToDo.list.allSatisfy { $0.isCompleted }
        
        if areAllSubToDosCompleted, !activeToDo.isDone {
            activeToDo = try await localDatabaseManager.update(object: activeToDo, withUpdates: [ToDo.CodingKeys.isDone.rawValue: true])
        } else {
            activeToDo = try await localDatabaseManager.update(object: activeToDo, withUpdates: [ToDo.CodingKeys.isDone.rawValue: false])
        }
        
        if let index = toDos.firstIndex(where: { $0.id == toDo.id }) {
            toDos[index] = activeToDo
        }
        
        try await updateTaskStatistics()

        self.toDo = activeToDo
    }
    
    func createSubToDo(toDo: ToDo, subToDos: [SubToDo]) async throws {
        let updatedToDo = try await localDatabaseManager.updateObjectWithChildren(object: toDo, children: subToDos, keyPath: ToDo.CodingKeys.list.rawValue)
        self.toDo = updatedToDo
    }
    
    func deleteToDo(primaryKey: String) async throws {
        try await localDatabaseManager.delete(object: ToDo.self, primaryKey: primaryKey)
    }
    
    func deleteAllToDos() async throws {
        try await localDatabaseManager.deleteAll()
    }
    
    func getLatestToDo() async throws -> ToDo? {
        let toDos = try await readActiveToDos()
        return toDos.max(by: { $0.executedDate < $1.executedDate })
    }
    
    func archiveToDo(toDo: ToDo) async throws {
        let data: [String : Any] = [ ToDo.CodingKeys.isArchived.rawValue : true ]
        
        try await updateToDo(toDo: toDo, data: data)
    }
    
    func readActiveToDos() async throws -> [ToDo] { toDos.filter { !$0.isArchived } }
    
    func readArchiveToDos() async throws -> [ToDo] { toDos.filter { $0.isArchived } }
}

//MARK: ToDo statistics
extension ToDoManager {
    private func updateTaskStatistics() async throws {
            doneTaskPercentage = try await calculateDoneToDosPercentage(toDos: toDos)
            categorizedCounts = filterDoneToDos()
        }
    
    func calculateDoneToDosPercentage(toDos: [ToDo]) async throws -> Double {
        
        let allToDo = toDos.count
        let doneToDo = toDos.filter({ $0.isDone }).count
        
        guard allToDo > 0 && doneToDo > 0 else {
            return 0
        }
        
        return Double(doneToDo) / Double(allToDo) * 100
    }
    
    func filterDoneToDos() -> [String: CategoryInfo] {
        guard toDos.filter({ $0.isDone }).isEmpty else {
            return numberOfCompletedTasksPerCategory()
        }
        
        return ["Done your tasks": .init(count: 1, color: Colors.color)]
    }
    
    private func numberOfCompletedTasksPerCategory() -> [String: CategoryInfo] {
        var counts = [String: Int]()
        
        for toDo in toDos {
            if toDo.isDone {
                if let count = counts[toDo.tag.rawValue] {
                    counts[toDo.tag.rawValue] = count + 1
                } else {
                    counts[toDo.tag.rawValue] = 1
                }
            }
        }
        
        let sortedCounts = counts.sorted(by: { $0.key < $1.key })
        
        var categorizedCounts = [String: CategoryInfo]()
        
        let colors = [Colors.color, Colors.color1, Colors.color2]
        
        for (index, (category, count)) in sortedCounts.enumerated() {
            if index < 2 {
                categorizedCounts[category] = CategoryInfo(count: count, color: colors[index])
            } else {
                if let otherCount = categorizedCounts["Other"] {
                    categorizedCounts["Other"] = CategoryInfo(count: otherCount.count + count, color: otherCount.color)
                } else {
                    categorizedCounts["Other"] = CategoryInfo(count: count, color: colors[index])
                }
            }
        }
        return categorizedCounts
    }
}
