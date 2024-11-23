//
//  SubToDo.swift
//  ToDo
//
//  Created by Kamil Wójcicki on 03/11/2024.
//

import Foundation
import LocalDatabaseInterface

public struct SubToDo: LocalStorable {
    public let id: String
    public var title: String
    public var isCompleted: Bool
    
    public init(
        id: String = UUID().uuidString,
        title: String,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }
    
    public init(from dao: SubToDoDAO) {
        self.id = dao.id
        self.title = dao.title
        self.isCompleted = dao.isCompleted
    }
    
    public enum CodingKeys: String, CodingKey {
        case id
        case title
        case isCompleted
    }
}
