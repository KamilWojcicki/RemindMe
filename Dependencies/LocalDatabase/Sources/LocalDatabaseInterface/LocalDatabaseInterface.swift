//
//  LocalDatabaseInterface.swift
//  
//
//  Created by Kamil Wójcicki on 14/04/2024.
//

import Foundation
import RealmSwift

public protocol LocalDAOInterface: Identifiable, Object {
    associatedtype LocalModel: LocalStorable
    init(from: LocalModel)
}

public protocol LocalStorable: Identifiable, Codable, Equatable, Hashable {
    associatedtype LocalDAO: LocalDAOInterface
    associatedtype ListData: LocalStorable
    
    init(from: LocalDAO)
    
    var list: [ListData] { get }
}

public extension LocalStorable {
    var list: [ListData] { [] }
}

public protocol LocalDatabaseManagerInterface {
    func create<Object: LocalStorable>(_ object: Object) async throws -> Object
    func create<Object: LocalStorable>(_ objects: [Object]) async throws
    func read<Object: LocalStorable>(primaryKey: String) async throws -> Object
    func read<Object: LocalStorable>() async throws -> [Object]
    func update<Object: LocalStorable>(object: Object, withUpdates updates: [String : Any]) async throws -> Object
    func delete<Object: LocalStorable>(object: Object.Type, primaryKey: String) async throws
    func deleteAllWithSpecificType<Object: LocalStorable>(object: Object.Type) async throws
    func deleteAll() async throws
    func updateObjectWithChildren<Object: LocalStorable, ChildObject: LocalStorable>(
        object: Object,
        children: [ChildObject],
        keyPath: String
    ) async throws -> Object
}

public enum LocalDatabaseManagerError: Error {
    case unableToInitializeRealm
    case unableToCreate
    case unableToRead
    case unableToUpdate
    case unableToDelete
}
