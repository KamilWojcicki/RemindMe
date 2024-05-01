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
        Assemblies.resolve(TabCoordinatorInterface.self).register(tab: .settings)
    }
}

extension Tab {
    public static var settings: Tab {
        Tab(
            title: "Settings",
            image: "gearshape",
            activeImage: "gearshape.fill",
            rootView: AnyView(SettingsView())
        )
    }
}
