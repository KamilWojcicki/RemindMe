// The Swift Programming Language
// https://docs.swift.org/swift-book

import DependencyInjection
import NavigationInterface
import SwiftUI

public struct Dependencies {
    public static func inject() {
        injectShared()
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
