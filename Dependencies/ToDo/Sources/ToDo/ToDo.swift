// The Swift Programming Language
// https://docs.swift.org/swift-book

import DependencyInjection
import LocalDatabase
import ToDoInterface

public struct Dependencies {
    public static func inject() {
        //TODO: inject assemblies of ToDo Manager
        Assemblies.inject(type: ToDoManagerInterface.self, object: ToDoManager())
        
        LocalDatabase.Dependencies.inject()
    }
}
