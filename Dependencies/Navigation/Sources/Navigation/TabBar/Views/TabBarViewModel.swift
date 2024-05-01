//
//  TabBarViewModel.swift
//
//
//  Created by Kamil Wójcicki on 08/04/2024.
//

import DependencyInjection
import Foundation
import NavigationInterface
import SwiftUI

//MARK: Create TabBarViewModel
@MainActor
final class TabBarViewModel: ObservableObject {
    @Inject private var tabCoordinator: TabCoordinatorInterface
    @Published private(set) var tabs: [Tab] = []
    @Published var selectedTab: String?
    
    init() {
        self.tabs = tabCoordinator.tabs
        self.selectedTab = ""
    }
    
    func tapped(tab: String) {
        withAnimation {
            self.selectedTab = tab
        }
    }
}
