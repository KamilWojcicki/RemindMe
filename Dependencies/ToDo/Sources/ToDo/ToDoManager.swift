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
    
    let updatedTask = PassthroughSubject<ToDo?, Never>()
    let updatedTasks = PassthroughSubject<[ToDo], Never>()
    let updatedDoneTaskPercentage = PassthroughSubject<Double, Never>()
    let updatedCategorizedCounts = PassthroughSubject<[String: CategoryInfo], Never>()
    
    private var task: ToDo? {
        didSet {
            updatedTask.send(task)
        }
    }
    
    private var tasks: [ToDo] = [] {
        didSet {
            updatedTasks.send(tasks)
        }
    }
    
    private var doneTaskPercentage: Double = 0 {
        didSet {
            updatedDoneTaskPercentage.send(doneTaskPercentage)
        }
    }
    
    private var categorizedCounts: [String: CategoryInfo] = [:] {
        didSet {
            updatedCategorizedCounts.send(categorizedCounts)
        }
    }
    
    func createToDo(todo: ToDo) async throws {
        let newToDo = try await localDatabaseManager.create(todo)
        
        tasks.append(newToDo)
    }
    
    func readToDo(primaryKey: String) async throws -> ToDo {
        try await localDatabaseManager.read(primaryKey: primaryKey)
    }
    
    func readAllToDos() async throws -> [ToDo] {
        self.tasks = try await localDatabaseManager.read()
        
        try await updateTaskStatistics()
        
        return tasks
    }
    
    func updateToDo(todo: ToDo, data: [String : Any]) async throws {
        let updatedTask = try await localDatabaseManager.update(type: todo, withUpdates: data)
        
        if let index = tasks.firstIndex(where: { $0.id == todo.id }) {
                    tasks[index] = updatedTask
                }
//        self.task = updatedTask
        
        try await updateTaskStatistics()

    }
    
    func updateSubToDo(task: ToDo, subToDo: SubToDo, data: [String : Any]) async throws {
        let updatedSubToDo = try await localDatabaseManager.update(type: subToDo, withUpdates: data)
        
        var activeToDo = try await readToDo(primaryKey: task.id)
        
        if let index = activeToDo.subtasks.firstIndex(where: { $0.id == subToDo.id }) {
                activeToDo.subtasks[index] = updatedSubToDo
            }
        
        self.task = activeToDo
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
    
    func archiveToDo(toDo: ToDo) async throws {
        let data: [String : Any] = [ ToDo.CodingKeys.isArchived.rawValue : true ]
        
        try await updateToDo(todo: toDo, data: data)
    }
    
    func readActiveToDos() async throws -> [ToDo] { tasks.filter { !$0.isArchived } }
    
    func readArchiveToDos() async throws -> [ToDo] { tasks.filter { $0.isArchived } }
}

//MARK: ToDo statistics
extension ToDoManager {
    private func updateTaskStatistics() async throws {
            doneTaskPercentage = try await calculateDoneTaskPercentage(tasks: tasks)
            categorizedCounts = filterDoneTasks()
        }
    
    func calculateDoneTaskPercentage(tasks: [ToDo]) async throws -> Double {
        
        let allToDo = tasks.count
        let doneToDo = tasks.filter({ $0.isDone }).count
        
        guard allToDo > 0 && doneToDo > 0 else {
            return 0
        }
        
        return Double(doneToDo) / Double(allToDo) * 100
    }
    
    func filterDoneTasks() -> [String: CategoryInfo] {
        guard tasks.filter({ $0.isDone }).isEmpty else {
            return numberOfCompletedTasksPerCategory()
        }
        
        return ["Done your tasks": .init(count: 1, color: Colors.color)]
    }
    
    private func numberOfCompletedTasksPerCategory() -> [String: CategoryInfo] {
        var counts = [String: Int]()
        
        for task in tasks {
            if task.isDone {
                if let count = counts[task.tag.rawValue] {
                    counts[task.tag.rawValue] = count + 1
                } else {
                    counts[task.tag.rawValue] = 1
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
