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
    init(from: LocalDAO)
}

public protocol LocalDatabaseManagerInterface {
    func create<Object: LocalStorable>(_ object: Object) async throws
    func create<Object: LocalStorable>(_ objects: [Object]) async throws
    func read<Object: LocalStorable>(type: Object.Type, primaryKey: String) async throws -> Object
    func read<Object: LocalStorable>() async throws -> [Object]
    func update<Object: LocalStorable>(type: Object.Type, withUpdates updates: [String : Any]) async throws
    func delete<Object: LocalStorable>(type: Object.Type, primaryKey: String) async throws
    func deleteAllWithSpecificType<Object: LocalStorable>(type: Object.Type) async throws
    func deleteAll() async throws
}

public enum LocalDatabaseManagerError: Error {
    case unableToInitializeRealm
    case unableToCreate
    case unableToRead
    case unableToUpdate
    case unableToDelete
}
