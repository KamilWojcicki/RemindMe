// The Swift Programming Language
// https://docs.swift.org/swift-book

import DependencyInjection
import History
import Home
import Navigation
import Settings
import Tasks

public struct Dependencies {
    public static func inject() {
        Navigation.Dependencies.inject()
        Home.Dependencies.inject()
        History.Dependencies.inject()
        Tasks.Dependencies.inject()
        Settings.Dependencies.inject()
    }
}
