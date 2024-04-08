import DependencyInjection
import SwiftUI
import NavigationInterface

public struct Dependencies {
    public static func inject() {
        injectShared()
    }
    
    public static func injectShared() {
        Assemblies.inject(type: TabCoordinatorInterface.self, object: TabCoordinator(), inObjectScope: .container)
    }
}
