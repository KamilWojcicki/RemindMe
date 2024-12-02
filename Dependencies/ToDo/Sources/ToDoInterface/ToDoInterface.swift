//
//  ToDoInterface.swift
//  
//
//  Created by Kamil Wójcicki on 18/04/2024.
//

import Combine
import Foundation
import SwiftUI

public enum Repetition: String, Codable, CaseIterable {
    case noRepeat = "No Repeat"
    case daily = "Daily"
    case weekdays = "Weekdays"
    case weekends = "Weekends"
    case weekly = "Weekly"
    case fortnightly = "Fortnightly"
    case monthly = "Monthly"
    case every3Months = "Every 3 Months"
    case every6Months = "Every 6 Months"
    case yearly = "Yearly"
    
    public var description: String {
        switch self {
        case .noRepeat:
            "No repetition"
        case .daily:
            "Repetition every day"
        case .weekdays:
            "Repetition every weekday"
        case .weekends:
            "Repetition every weekends"
        case .weekly:
            "Repetition every week"
        case .fortnightly:
            "Repetition every two weeks"
        case .monthly:
            "Repetition every month"
        case .every3Months:
            "Repetition every 3 months"
        case .every6Months:
            "Repetition every 6 months"
        case .yearly:
            "Repetition every year"
        }
    }
}

public enum Tag: String, CaseIterable, Codable {
    case all = "All"
    case birthday = "Birthday"
    case shoppingList = "Shopping List"
    case holidayEvent = "Holiday Event"
    case medicalCheck = "Medical Check"
    case trip = "Trip"
    case otherEvent = "Other Event"
}

public enum Picker {
    case date
    case time
    case reminder
    case repetition
    case tag
    case subToDo
    case editSubToDo
    case title
}

public struct CategoryInfo {
    public let count: Int
    public let color: Color
    
    public init(count: Int, color: Color) {
        self.count = count
        self.color = color
    }
}

public protocol ToDoManagerInterface {
    var updatedToDo: PassthroughSubject<ToDo?, Never> { get }
    var updatedToDos: PassthroughSubject<[ToDo], Never> { get }
    var updatedDoneToDosPercentage: PassthroughSubject<Double, Never> { get }
    var updatedCategorizedCounts: PassthroughSubject<[String: CategoryInfo], Never> { get }
    
    func createToDo(toDo: ToDo) async throws
    func readToDo(primaryKey: String) async throws -> ToDo
    func readAllToDos() async throws -> [ToDo]
    func updateToDo(toDo: ToDo, data: [String : Any]) async throws
    func createSubToDo(toDo: ToDo, subToDos: [SubToDo]) async throws
    func updateSubToDo(toDo: ToDo, subToDo: SubToDo, data: [String : Any]) async throws
    func deleteToDo(primaryKey: String) async throws
    func deleteAllToDos() async throws
    func getLatestToDo() async throws -> ToDo?
    func archiveToDo(toDo: ToDo) async throws
    func readActiveToDos() async throws -> [ToDo]
    func readArchiveToDos() async throws -> [ToDo]
    func calculateDoneToDosPercentage(toDos: [ToDo]) async throws -> Double
    func filterDoneToDos() -> [String: CategoryInfo]
    
//    //delete if expired
//    func archiveExpiredToDos() async throws
}
