//
//  ToDoInterface.swift
//  
//
//  Created by Kamil Wójcicki on 18/04/2024.
//

import Design
import Foundation
import LocalDatabaseInterface
import RealmSwift

public enum Categories: String, CaseIterable, Codable, PersistableEnum {
    case birthday = "Birthday"
    case shoppingList = "Shopping List"
    case holidayEvent = "Holiday Event"
    case medicalCheck = "Medical Check"
    case trip = "Trip"
    case otherEvent = "Other Event"
    
    public var image: String {
        switch self {
        case .birthday:
            Symbols.giftFill
        case .shoppingList:
            Symbols.checklist
        case .holidayEvent:
            Symbols.airplaneCircleFill
        case .medicalCheck:
            Symbols.crossCircleFill
        case .trip:
            Symbols.carFill
        case .otherEvent:
            Symbols.starFill
        }
    }
}

public struct ToDo: LocalStorable {
    public let id: String
    public let category: Categories
    public let name: String
    public let toDoDescription: String?
    public let executedTime: Date
    public let numbersOfReminders: Int?
    
    public init(id: String = UUID().uuidString, category: Categories, name: String, toDoDescription: String, executedTime: Date, numbersOfReminders: Int) {
        self.id = id
        self.category = category
        self.name = name
        self.toDoDescription = toDoDescription
        self.executedTime = executedTime
        self.numbersOfReminders = numbersOfReminders
    }
    
    public init(from dao: ToDoDAO) {
        self.id = dao.id
        self.category = dao.category
        self.name = dao.name
        self.toDoDescription = dao.toDoDescription
        self.executedTime = dao.executedTime
        self.numbersOfReminders = dao.numbersOfReminders
    }
    
    public enum CodingKeys: String, CodingKey {
        case id
        case category
        case name
        case toDoDescription
        case executedTime
        case numbersOfReminders
    }
}

public final class ToDoDAO: RealmSwift.Object, LocalDAOInterface {
    
    @Persisted(primaryKey: true) public var id: String
    @Persisted public var name: String
    @Persisted public var category: Categories
    @Persisted public var toDoDescription: String?
    @Persisted public var executedTime: Date
    @Persisted public var numbersOfReminders: Int?
    
    override public init() {
        super.init()
        self.name = ""
        self.category = Categories.otherEvent
        self.toDoDescription = ""
        self.executedTime = Date()
        self.numbersOfReminders = 0
    }
    
    public init(from todo: ToDo) {
        super.init()
        self.id = todo.id
        self.category = todo.category
        self.name = todo.name
        self.toDoDescription = todo.toDoDescription
        self.executedTime = todo.executedTime
        self.numbersOfReminders = todo.numbersOfReminders
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
