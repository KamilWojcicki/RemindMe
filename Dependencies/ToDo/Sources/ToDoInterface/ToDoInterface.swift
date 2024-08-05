//
//  ToDoInterface.swift
//  
//
//  Created by Kamil Wójcicki on 18/04/2024.
//

import Combine
import Design
import Foundation
import LocalDatabaseInterface
import RealmSwift
import SwiftUI
import Utilities

public struct CategoryInfo {
    public let count: Int
    public let color: Color
    
    public init(count: Int, color: Color) {
        self.count = count
        self.color = color
    }
}

public enum Category: String, CaseIterable, Codable, PersistableEnum {
    case all
    case birthday = "Birthday"
    case shoppingList = "Shopping List"
    case holidayEvent = "Holiday Event"
    case medicalCheck = "Medical Check"
    case trip = "Trip"
    case otherEvent = "Other Event"
    
//    public var image: String {
//        switch self {
//        case .birthday:
//            Symbols.giftFill
//        case .shoppingList:
//            Symbols.checklist
//        case .holidayEvent:
//            Symbols.airplaneCircleFill
//        case .medicalCheck:
//            Symbols.crossCircleFill
//        case .trip:
//            Symbols.carFill
//        case .otherEvent:
//            Symbols.starFill
//        }
//    }
}

public struct ToDo: LocalStorable {
    public let id: String
    public let category: Category
    public let name: String
    public let toDoDescription: String?
    public let executedDate: Date
    public let startExecutedTime: Date?
    public let endExecutedTime: Date?
    public let numbersOfReminders: Int?
    public let isArchived: Bool
    public let isDone: Bool
    
    public init(
        id: String = UUID().uuidString,
        category: Category,
        name: String,
        toDoDescription: String,
        executedDate: Date,
        startExecutedTime: Date?,
        endExecutedTime: Date?,
        numbersOfReminders: Int,
        isArchived: Bool = false,
        isDone: Bool = false
    ) {
        self.id = id
        self.category = category
        self.name = name
        self.toDoDescription = toDoDescription
        self.executedDate = executedDate
        self.startExecutedTime = startExecutedTime
        self.endExecutedTime = endExecutedTime
        self.numbersOfReminders = numbersOfReminders
        self.isArchived = isArchived
        self.isDone = isDone
    }
    
    public init(from dao: ToDoDAO) {
        self.id = dao.id
        self.category = dao.category
        self.name = dao.name
        self.toDoDescription = dao.toDoDescription
        self.executedDate = dao.executedDate
        self.startExecutedTime = dao.startExecutedTime
        self.endExecutedTime = dao.endExecutedTime
        self.numbersOfReminders = dao.numbersOfReminders
        self.isArchived = dao.isArchived
        self.isDone = dao.isDone
    }
    
    public enum CodingKeys: String, CodingKey {
        case id
        case category
        case name
        case toDoDescription
        case executedDate
        case startExecutedTime
        case endExecutedTime
        case numbersOfReminders
        case isArchived
        case isDone
    }
}

public final class ToDoDAO: RealmSwift.Object, LocalDAOInterface {
    
    @Persisted(primaryKey: true) public var id: String
    @Persisted public var name: String
    @Persisted public var category: Category
    @Persisted public var toDoDescription: String?
    @Persisted public var executedDate: Date
    @Persisted public var startExecutedTime: Date?
    @Persisted public var endExecutedTime: Date?
    @Persisted public var numbersOfReminders: Int?
    @Persisted public var isArchived: Bool
    @Persisted public var isDone: Bool
    
    override public init() {
        super.init()
        self.name = ""
        self.category = Category.otherEvent
        self.toDoDescription = ""
        self.executedDate = Date()
        self.startExecutedTime = Date()
        self.endExecutedTime = Date()
        self.numbersOfReminders = 0
        self.isArchived = false
        self.isDone = false
    }
    
    public init(from todo: ToDo) {
        super.init()
        self.id = todo.id
        self.category = todo.category
        self.name = todo.name
        self.toDoDescription = todo.toDoDescription
        self.executedDate = todo.executedDate
        self.startExecutedTime = todo.startExecutedTime
        self.endExecutedTime = todo.endExecutedTime
        self.numbersOfReminders = todo.numbersOfReminders
        self.isArchived = todo.isArchived
        self.isDone = todo.isDone
    }
}

public protocol ToDoManagerInterface {
    var updatedCategory: PassthroughSubject<ToDoInterface.Category?, Never> { get }
    
    func createToDo(todo: ToDo) async throws
    func readToDo(primaryKey: String) async throws -> ToDo
    func readAllToDos() async throws -> [ToDo]
    func updateToDo(data: [String : Any]) async throws
    func deleteToDo(primaryKey: String) async throws
    func deleteAllToDos() async throws
    func getLatestToDo() async throws -> ToDo?
    func archiveToDo(primaryKey: String) async throws
    func readActiveToDos() async throws -> [ToDo]
    func readArchiveToDos() async throws -> [ToDo]
    //category
    func updateCategory(newCategory: ToDoInterface.Category?)
    //delete if expired
    func archiveExpiredToDos() async throws
}
