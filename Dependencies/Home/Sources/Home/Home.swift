// The Swift Programming Language
// https://docs.swift.org/swift-book

import DependencyInjection
import NavigationInterface
import SwiftUI
import ToDo

public struct Dependencies {
    public static func inject() {
        injectShared()
        ToDo.Dependencies.inject()
    }
    
    public static func injectShared() {
        Assemblies.resolve(TabCoordinatorInterface.self).register(tab: .home)
    }
}

extension Tab {
    public static var home: Tab {
        Tab(
            title: "Home",
            image: "house",
            activeImage: "house.fill",
            rootView: AnyView(HomeView())
        )
    }
}
