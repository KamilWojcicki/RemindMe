//
//  LocalDatabaseManager.swift
//
//
//  Created by Kamil Wójcicki on 14/04/2024.
//

import Foundation
import LocalDatabaseInterface
import RealmSwift

fileprivate struct DAOFactory {
    static func initializeObject<DAO: LocalDAOInterface, Object: LocalStorable>(from dao: DAO) -> Object {
        guard let dao = dao as? Object.LocalDAO else {
            fatalError()
        }
        
        return Object(from: dao)
    }
    
    static func initializeDAO<Object: LocalStorable, DAO: LocalDAOInterface>(from object: Object) -> DAO {
        guard let object = object as? DAO.LocalModel else {
            fatalError()
        }
        
        return DAO(from: object)
    }
}

actor LocalDatabaseManager {
    private var realm: Realm?
    
    private func ensureRealmIsOpen() async throws {
        if realm == nil {
            try await initializeRealm()
        }
    }
    
    private func initializeRealm() async throws {
        do {
            self.realm = try await Realm(actor: self)
            print("\nInitialized Realm: \(realm?.configuration.fileURL?.absoluteString ?? "--")\n")
        } catch {
            throw LocalDatabaseManagerError.unableToInitializeRealm
        }
    }
}

extension LocalDatabaseManager: LocalDatabaseManagerInterface {
    
    func create<Object: LocalStorable>(_ object: Object) async throws {
        try await ensureRealmIsOpen()
        let objectDAO: Object.LocalDAO = DAOFactory.initializeDAO(from: object)
        
        do {
            try await realm?.asyncWrite {
                realm?.add(objectDAO, update: .modified)
            }
        } catch {
            throw LocalDatabaseManagerError.unableToCreate
        }
    }
    
    func create<Object: LocalStorable>(_ objects: [Object]) async throws {
        try await ensureRealmIsOpen()
        let objectsDAO: [Object.LocalDAO] = objects.map { DAOFactory.initializeDAO(from: $0) }
        
        do {
            try await realm?.asyncWrite {
                realm?.add(objectsDAO)
            }
        } catch {
            throw LocalDatabaseManagerError.unableToCreate
        }
    }
    
    func read<Object: LocalStorable>(type: Object.Type, primaryKey: String) async throws -> Object {
        try await ensureRealmIsOpen()
        
        guard let objectDAO = realm?.object(ofType: Object.LocalDAO.self, forPrimaryKey: primaryKey) else {
            throw LocalDatabaseManagerError.unableToRead
        }
        
        return DAOFactory.initializeObject(from: objectDAO)
    }
    
    func read<Object: LocalStorable>() async throws -> [Object] {
        try await ensureRealmIsOpen()
        
        guard let objectsDAO = realm?.objects(Object.LocalDAO.self) else {
            throw LocalDatabaseManagerError.unableToRead
        }
        
        return objectsDAO.map { DAOFactory.initializeObject(from: $0) }
    }
    
    func update<Object: LocalStorable>(type: Object.Type, withUpdates updates: [String : Any]) async throws {
        try await ensureRealmIsOpen()
        
        do {
            try await realm?.asyncWrite {
                realm?.create(Object.LocalDAO.self, value: updates, update: .modified)
            }
        } catch {
            throw LocalDatabaseManagerError.unableToUpdate
        }
    }
    
    func delete<Object: LocalStorable>(type: Object.Type, primaryKey: String) async throws {
        try await ensureRealmIsOpen()
        guard let objectDAO = realm?.object(ofType: Object.LocalDAO.self, forPrimaryKey: primaryKey) else {
            throw LocalDatabaseManagerError.unableToRead
        }
        
        do {
            try await realm?.asyncWrite {
                realm?.delete(objectDAO)
            }
        } catch {
            throw LocalDatabaseManagerError.unableToDelete
        }
    }
    
    func deleteAllWithSpecificType<Object: LocalStorable>(type: Object.Type) async throws {
        try await ensureRealmIsOpen()
        
        do {
            try await realm?.asyncWrite {
                guard let objectsDAO = realm?.objects(Object.LocalDAO.self) else {
                    throw LocalDatabaseManagerError.unableToRead
                }
                realm?.delete(objectsDAO)
            }
        } catch {
            throw LocalDatabaseManagerError.unableToDelete
        }
    }
    
    func deleteAll() async throws {
        try await ensureRealmIsOpen()
        
        do {
            try await realm?.asyncWrite {
                realm?.deleteAll()
            }
        } catch {
            throw LocalDatabaseManagerError.unableToDelete
        }
    }
}
