//
//  ToDo.swift
//  ToDo
//
//  Created by Kamil Wójcicki on 03/11/2024.
//

import LocalDatabaseInterface
import SwiftUI

public struct ToDo: LocalStorable {
    public let id: String
    public var name: String
    public let symbol: String
    public let image: Data?
    public let executedDate: Date
    public let executedTime: Date
    public let remindTime: Date?
    public let reminderRepetition: Repetition
    public let tag: Tag
    public var list: [SubToDo]
    public let isArchived: Bool
    public var isDone: Bool
    
    public init(
        id: String = UUID().uuidString,
        name: String,
        symbol: String,
        image: Data?,
        executedDate: Date,
        executedTime: Date,
        remindTime: Date?,
        reminderRepetition: Repetition,
        tag: Tag,
        subToDos: [SubToDo],
        isArchived: Bool = false,
        isDone: Bool = false
    ) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.image = image
        self.executedDate = executedDate
        self.executedTime = executedTime
        self.remindTime = remindTime
        self.reminderRepetition = reminderRepetition
        self.tag = tag
        self.list = subToDos
        self.isArchived = isArchived
        self.isDone = isDone
    }
    
    public init(task: ToDo, isDone: Bool) {
        self.id = task.id
        self.name = task.name
        self.symbol = task.symbol
        self.image = task.image
        self.executedDate = task.executedDate
        self.executedTime = task.executedTime
        self.remindTime = task.remindTime
        self.reminderRepetition = task.reminderRepetition
        self.tag = task.tag
        self.list = task.list
        self.isArchived = task.isArchived
        self.isDone = isDone
    }
    
    public init(task: ToDo, subToDos: [SubToDo]) {
        self.id = task.id
        self.name = task.name
        self.symbol = task.symbol
        self.image = task.image
        self.executedDate = task.executedDate
        self.executedTime = task.executedTime
        self.remindTime = task.remindTime
        self.reminderRepetition = task.reminderRepetition
        self.tag = task.tag
        self.list = subToDos
        self.isArchived = task.isArchived
        self.isDone = task.isDone
    }
    
    public init(from dao: ToDoDAO) {
        self.id = dao.id
        self.name = dao.name
        self.symbol = dao.symbol
        self.image = dao.image
        self.executedDate = dao.executedDate
        self.executedTime = dao.executedTime
        self.remindTime = dao.remindTime
        self.reminderRepetition = Repetition(rawValue: dao.reminderRepetition ?? "") ?? .daily
        self.tag = Tag(rawValue: dao.tag) ?? .all
        self.list = dao.list.map { SubToDo(from: $0) }
        self.isArchived = dao.isArchived
        self.isDone = dao.isDone
    }
    
    public enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case image
        case executedDate
        case executedTime
        case remindTime
        case reminderRepetition
        case tag
        case list
        case isArchived
        case isDone
    }
}
