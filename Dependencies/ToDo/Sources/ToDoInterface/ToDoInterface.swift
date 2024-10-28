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

public struct Icon: Hashable {
    public let symbol: Data?
    public let circleColor: Color

    public init(symbol: Data, circleColor: Color) {
        self.symbol = symbol
        self.circleColor = circleColor
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(symbol?.hashValue)
        hasher.combine(circleColor.description)
    }
    
    public static func == (lhs: Icon, rhs: Icon) -> Bool {
        lhs.symbol == rhs.symbol && lhs.circleColor == rhs.circleColor
    }

    public static let tapIcon       = Icon(symbol: Icons.tap?.pngData() ?? Data(), circleColor: .blue.opacity(0.2))
    public static let dishIcon      = Icon(symbol: Icons.dinner?.pngData() ?? Data(), circleColor: .brown)
    public static let trayIcon      = Icon(symbol: Icons.tray?.pngData() ?? Data(), circleColor: .blue.opacity(0.2))
    public static let clipboardIcon = Icon(symbol: Icons.clipboard?.pngData() ?? Data(), circleColor: .yellow)
    public static let photoIcon     = Icon(symbol: Icons.photo?.pngData() ?? Data(), circleColor: .blue.opacity(0.1))
    public static let birthdayIcon  = Icon(symbol: Icons.birthday?.pngData() ?? Data(), circleColor: .yellow.opacity(0.5))
    public static let catIcon       = Icon(symbol: Icons.cat?.pngData() ?? Data(), circleColor: .green.opacity(0.6))
    public static let cinemaIcon    = Icon(symbol: Icons.cinema?.pngData() ?? Data(), circleColor: .red.opacity(0.5))
    public static let dentist       = Icon(symbol: Icons.dentist?.pngData() ?? Data(), circleColor: .green.opacity(0.7))
    public static let dog           = Icon(symbol: Icons.dog?.pngData() ?? Data(), circleColor: .yellow.opacity(0.7))
    public static let football      = Icon(symbol: Icons.football?.pngData() ?? Data(), circleColor: .purple.opacity(0.4))
    public static let learning      = Icon(symbol: Icons.learning?.pngData() ?? Data(), circleColor: .blue.opacity(0.4))
    public static let roadTrip      = Icon(symbol: Icons.roadTrip?.pngData() ?? Data(), circleColor: .red.opacity(0.3))
    public static let running       = Icon(symbol: Icons.running?.pngData() ?? Data(), circleColor: .red.opacity(0.4))
    public static let shopping      = Icon(symbol: Icons.shopping?.pngData() ?? Data(), circleColor: .yellow.opacity(0.5))
    public static let vacation      = Icon(symbol: Icons.vacation?.pngData() ?? Data(), circleColor: .orange.opacity(0.6))
    
    public static let allIcons: [Icon] = [
        dishIcon,
        clipboardIcon,
        birthdayIcon,
        catIcon,
        cinemaIcon,
        dentist,
        dog,
        football,
        learning,
        roadTrip,
        running,
        shopping,
        vacation
    ]
}

public class IconObject: EmbeddedObject {
    @Persisted var symbol: Data?
    @Persisted var circleColor: PersistableColor?
}

// Extend the Icon struct to conform to CustomPersistable
extension Icon: CustomPersistable {
    public typealias PersistedType = IconObject
    
    // Initialize Icon from the stored IconObject
    public init(persistedValue: IconObject) {
        let circleColor = persistedValue.circleColor?.toColor() ?? .clear  // Fallback to clear if no color
        self.symbol = persistedValue.symbol
        self.circleColor = circleColor
    }
    
    // Convert the Icon struct to its persistable form
    public var persistableValue: PersistedType {
        let iconObject = IconObject()
        iconObject.symbol = self.symbol
        iconObject.circleColor = PersistableColor(color: self.circleColor)
        return iconObject
    }
}

//Persistable Color
public class PersistableColor: EmbeddedObject {
    @Persisted var red: Double = 0
    @Persisted var green: Double = 0
    @Persisted var blue: Double = 0
    @Persisted var opacity: Double = 1  // Default to fully opaque
    
    // Initialize with a Color instance
    convenience init(color: Color) {
        self.init()
        let uiColor = UIColor(color)  // Convert to UIColor to extract components
        if let components = uiColor.cgColor.components, components.count >= 3 {
            red = Double(components[0])
            green = Double(components[1])
            blue = Double(components[2])
            opacity = components.count > 3 ? Double(components[3]) : 1.0
        }
    }
    
    // Helper function to convert PersistableColor back to Color
    func toColor() -> Color {
        return Color(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}

extension Color: CustomPersistable {
    public typealias PersistedType = PersistableColor
    
    // Initialize Color from a PersistableColor
    public init(persistedValue: PersistableColor) {
        self.init(
            .sRGB,
            red: persistedValue.red,
            green: persistedValue.green,
            blue: persistedValue.blue,
            opacity: persistedValue.opacity
        )
    }
    
    // Convert Color to PersistableColor
    public var persistableValue: PersistableColor {
        return PersistableColor(color: self)
    }
}

public enum Repetition: String, Codable, CaseIterable, PersistableEnum {
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

public class ReminderObject: EmbeddedObject {
    @Persisted var type: String // Will store the enum case ("noReminder" or "reminderAt")
    @Persisted var date: Date?  // Will store the date for reminderAt case
}

// Extend the Reminder enum to conform to CustomPersistable
extension Reminder: CustomPersistable {
    public typealias PersistedType = ReminderObject
    
    // Initialize Reminder from the stored ReminderObject
    public init(persistedValue: ReminderObject) {
        switch persistedValue.type {
        case "noReminder":
            self = .noReminder
        case "reminderAt":
            if let date = persistedValue.date {
                self = .reminderAt(date)
            } else {
                self = .noReminder // Fallback in case of a missing date
            }
        default:
            self = .noReminder // Default case if type is unknown
        }
    }
    
    // Convert the Reminder enum to its persistable form
    public var persistableValue: PersistedType {
        let reminderObject = ReminderObject()
        
        switch self {
        case .noReminder:
            reminderObject.type = "noReminder"
            reminderObject.date = nil
        case .reminderAt(let date):
            reminderObject.type = "reminderAt"
            reminderObject.date = date
        }
        
        return reminderObject
    }
}

// The original Reminder enum that you wanted
public enum Reminder: Codable {
    case noReminder
    case reminderAt(Date)
    
    public var description: String {
        switch self {
        case .noReminder:
            return "No reminder"
        case .reminderAt(let date):
            return "Remind: \(dateFormatter(dateFormat: .time).string(from: date))"
        }
    }
    
    public var date: Date? {
        switch self {
        case .noReminder:
            return nil
        case .reminderAt(let date):
            return date
        }
    }
    
    mutating public func setDate(_ date: Date) {
        self = .reminderAt(date)
    }
}

public class DayObject: EmbeddedObject {
    @Persisted var type: String // Will store the enum case ("today" or "otherDay")
    @Persisted var date: Date?  // Will store the date for otherDay case
}

// Extend the Day enum to conform to CustomPersistable
extension Day: CustomPersistable {
    public typealias PersistedType = DayObject
    
    // Initialize Day from the stored DayObject
    public init(persistedValue: DayObject) {
        switch persistedValue.type {
        case "today":
            self = .today
        case "otherDay":
            if let date = persistedValue.date {
                self = .otherDay(date)
            } else {
                self = .today // Fallback in case of a missing date
            }
        default:
            self = .today // Default case if type is unknown
        }
    }
    
    // Convert the Day enum to its persistable form
    public var persistableValue: PersistedType {
        let dayObject = DayObject()
        
        switch self {
        case .today:
            dayObject.type = "today"
            dayObject.date = nil
        case .otherDay(let date):
            dayObject.type = "otherDay"
            dayObject.date = date
        }
        
        return dayObject
    }
}

public enum Day: Codable, Comparable {
    case today
    case otherDay(Date)
    
    public var description: String {
        switch self {
        case .today:
            "Today"
        case .otherDay(let date):
            "\(dateFormatter(dateFormat: .dateWithDots).string(from: date))"
        }
    }
    
    public static func < (lhs: Day, rhs: Day) -> Bool {
            switch (lhs, rhs) {
            case (.today, .otherDay):
                return true
            case (.otherDay, .today):
                return false
            case (.otherDay(let lhsDate), .otherDay(let rhsDate)):
                return lhsDate < rhsDate
            case (.today, .today):
                return false
            }
        }

        public static func == (lhs: Day, rhs: Day) -> Bool {
            switch (lhs, rhs) {
            case (.today, .today):
                return true
            case (.otherDay(let lhsDate), .otherDay(let rhsDate)):
                return lhsDate == rhsDate
            default:
                return false
            }
        }
}

public enum Picker {
    case date
    case time
    case reminder
    case repetition
    case tag
    case subtask
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

public enum Tag: String, CaseIterable, Codable, PersistableEnum {
    case all = "All"
    case birthday = "Birthday"
    case shoppingList = "Shopping List"
    case holidayEvent = "Holiday Event"
    case medicalCheck = "Medical Check"
    case trip = "Trip"
    case otherEvent = "Other Event"
}

public struct ToDo: LocalStorable {
    public let id: String
    public let name: String
    public let symbol: Icon
    public let image: Data?
    public let executedDate: Day
    public let executedTime: Date
    public let remindTime: Reminder
    public let reminderRepetition: Repetition
    public let tag: Tag
    public let isArchived: Bool
    public let isDone: Bool
    
    public init(
        id: String = UUID().uuidString,
        name: String,
        symbol: Icon,
        image: Data?,
        executedDate: Day,
        executedTime: Date,
        remindTime: Reminder,
        reminderRepetition: Repetition,
        tag: Tag,
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
        self.isArchived = task.isArchived
        self.isDone = isDone
    }
    
    public init(from dao: ToDoDAO) {
        self.id = dao.id
        self.name = dao.name
        self.symbol = dao.symbol
        self.image = dao.image
        self.executedDate = dao.executedDate
        self.executedTime = dao.executedTime
        self.remindTime = dao.remindTime
        self.reminderRepetition = dao.reminderRepetition
        self.tag = dao.tag
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
        case isArchived
        case isDone
    }
}

public final class ToDoDAO: RealmSwift.Object, LocalDAOInterface {
    @Persisted(primaryKey: true) public var id: String
    @Persisted public var name: String
    @Persisted public var symbol: Icon
    @Persisted public var image: Data?
    @Persisted public var executedDate: Day
    @Persisted public var executedTime: Date
    @Persisted public var remindTime: Reminder
    @Persisted public var reminderRepetition: Repetition
    @Persisted public var tag: Tag
    @Persisted public var isArchived: Bool
    @Persisted public var isDone: Bool
    
    override public init() {
        super.init()
        self.name = ""
        self.symbol = .clipboardIcon
        self.image = Data()
        self.executedDate = .today
        self.executedTime = Date()
        self.remindTime = .noReminder
        self.reminderRepetition = .noRepeat
        self.tag = Tag.otherEvent
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
        self.reminderRepetition = todo.reminderRepetition
        self.tag = todo.tag
        self.isArchived = todo.isArchived
        self.isDone = todo.isDone
    }
}

public protocol ToDoManagerInterface {
    var updatedCategory: PassthroughSubject<ToDoInterface.Tag?, Never> { get }
    
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
//    //category
//    func updateCategory(newCategory: ToDoInterface.Category?)
//    //delete if expired
//    func archiveExpiredToDos() async throws
}
