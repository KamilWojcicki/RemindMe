// The Swift Programming Language
// https://docs.swift.org/swift-book

import DependencyInjection
import Navigation

public struct Dependencies {
    public static func inject() {
        Navigation.Dependencies.inject()
    }
}
