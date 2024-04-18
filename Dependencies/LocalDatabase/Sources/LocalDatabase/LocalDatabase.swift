// The Swift Programming Language
// https://docs.swift.org/swift-book

import DependencyInjection
import LocalDatabaseInterface

public struct Dependencies {
    public static func inject() {
        Assemblies.inject(type: LocalDatabaseManagerInterface.self, object: LocalDatabaseManager())
    }
}
