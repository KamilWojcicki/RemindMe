//
//  ToDoInterface.swift
//  
//
//  Created by Kamil Wójcicki on 18/04/2024.
//

import Foundation
import LocalDatabaseInterface
import RealmSwift

public struct ToDo: LocalStorable {
    public let id: String
    public let name: String
    public let toDoDescription: String
    public let executedTime: Date
    
    public init(id: String = UUID().uuidString, name: String, toDoDescription: String, executedTime: Date) {
        self.id = id
        self.name = name
        self.toDoDescription = toDoDescription
        self.executedTime = executedTime
    }
    
    public init(from dao: ToDoDAO) {
        self.id = dao.id
        self.name = dao.name
        self.toDoDescription = dao.toDoDescription
        self.executedTime = dao.executedTime
    }
    
    public enum CodingKeys: String, CodingKey {
        case id
        case name
        case toDoDescription
        case executedTime
    }
}

public final class ToDoDAO: RealmSwift.Object, LocalDAOInterface {
    
    @Persisted(primaryKey: true) public var id: String
    @Persisted public var name: String
    @Persisted public var toDoDescription: String
    @Persisted var executedTime: Date
    
    override public init() {
        super.init()
        self.name = ""
        self.toDoDescription = ""
        self.executedTime = Date()
    }
    
    public init(from todo: ToDo) {
        super.init()
        self.id = todo.id
        self.name = todo.name
        self.toDoDescription = todo.toDoDescription
        self.executedTime = todo.executedTime
    }
}

public protocol ToDoManagerInterface {
    func createToDo(todo: ToDo) async throws
    func readToDo(primaryKey: String) async throws -> ToDo
    func readAllToDos() async throws -> [ToDo]
    func updateToDo(data: [String : Any]) async throws
    func deleteToDo(primaryKey: String) async throws
    func deleteAllToDos() async throws
    func getLatestToDo() async throws -> ToDo?
}
