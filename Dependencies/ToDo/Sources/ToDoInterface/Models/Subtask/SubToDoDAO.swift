//
//  SubToDoDAO.swift
//  ToDo
//
//  Created by Kamil Wójcicki on 03/11/2024.
//

import Foundation
import LocalDatabaseInterface
import RealmSwift

public final class SubToDoDAO: RealmSwift.Object, LocalDAOInterface {
    @Persisted(primaryKey: true) public var id: String
    @Persisted public var title: String
    @Persisted public var isCompleted: Bool
    
    override public init() {
        super.init()
        self.title = ""
        self.isCompleted = false
    }
    
    public init(from subtodo: SubToDo) {
        super.init()
        self.id = subtodo.id
        self.title = subtodo.title
        self.isCompleted = subtodo.isCompleted
    }
}
