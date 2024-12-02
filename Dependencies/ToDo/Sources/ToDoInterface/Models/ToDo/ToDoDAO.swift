//
//  ToDoDAO.swift
//  ToDo
//
//  Created by Kamil Wójcicki on 03/11/2024.
//

import Foundation
import LocalDatabaseInterface
import RealmSwift

public final class ToDoDAO: RealmSwift.Object, LocalDAOInterface {
    @Persisted(primaryKey: true) public var id: String
    @Persisted public var name: String
    @Persisted public var symbol: String
    @Persisted public var image: Data?
    @Persisted public var executedDate: Date
    @Persisted public var executedTime: Date
    @Persisted public var remindTime: Date?
    @Persisted public var reminderRepetition: String?
    @Persisted public var tag: String
    @Persisted public var list: RealmSwift.List<SubToDoDAO>
    @Persisted public var isArchived: Bool
    @Persisted public var isDone: Bool
    
    override public init() {
        super.init()
        self.name = ""
        self.symbol = ""
        self.image = Data()
        self.executedDate = Date()
        self.executedTime = Date()
        self.remindTime = nil
        self.reminderRepetition = nil
        self.tag = Tag.otherEvent.rawValue
        self.list = RealmSwift.List<SubToDoDAO>()
        self.isArchived = false
        self.isDone = false
    }
    
    public init(from todo: ToDo) {
        super.init()
        self.id = todo.id
        self.name = todo.name
        self.symbol = todo.symbol
        self.image = todo.image
        self.executedDate = todo.executedDate
        self.executedTime = todo.executedTime
        self.remindTime = todo.remindTime
        self.reminderRepetition = todo.reminderRepetition.description
        self.tag = todo.tag.rawValue
        self.list.append(objectsIn: todo.list.map { SubToDoDAO(from: $0) })
        self.isArchived = todo.isArchived
        self.isDone = todo.isDone
    }
}

