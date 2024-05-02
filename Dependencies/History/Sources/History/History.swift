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
        Assemblies.resolve(TabCoordinatorInterface.self).register(tab: .history)
    }
}

extension Tab {
    public static var history: Tab {
        Tab(
            title: "History",
            image: "archivebox",
            activeImage: "archivebox.fill",
            rootView: AnyView(HistoryView())
        )
    }
}
