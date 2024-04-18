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
    
    public init(id: String , name: String, toDoDescription: String) {
        self.id = id
        self.name = name
        self.toDoDescription = toDoDescription
    }
    
    public init(from dao: ToDoDAO) {
        self.id = dao._id.stringValue
        self.name = dao.name
        self.toDoDescription = dao.toDoDescription
    }
    
    public enum CodingKeys: String, CodingKey {
        case id
        case name
        case toDoDescription
    }
}

public final class ToDoDAO: RealmSwift.Object, LocalDAOInterface {
    
    @Persisted(primaryKey: true) public var _id: ObjectId
    @Persisted public var name: String
    @Persisted public var toDoDescription: String
    
    override public init() {
        super.init()
        self.toDoDescription = ""
        self.name = ""
    }
    
    public init(from todo: ToDo) {
        super.init()
        self._id = try! ObjectId(string: todo.id)
        self.name = todo.name
        self.toDoDescription = todo.toDoDescription
    }
}

public protocol ToDoManagerInterface {
    
}
