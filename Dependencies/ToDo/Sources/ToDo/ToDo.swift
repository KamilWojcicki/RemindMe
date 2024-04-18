// The Swift Programming Language
// https://docs.swift.org/swift-book

import DependencyInjection
import LocalDatabase

public struct Dependencies {
    public static func inject() {
        //TODO: inject assemblies of ToDo Manager
        
        LocalDatabase.Dependencies.inject()
    }
}
